class Item < ActiveRecord::Base
	include PublicActivity::Model
	tracked except: [:update, :destroy], owner: Proc.new{ |controller, model| controller.current_user }
	belongs_to :user
	belongs_to :group
	belongs_to :list
	mount_uploader :image, ImageUploader
	after_initialize :set_default_value

	auto_html_for :url do
	end
	
	def create_title
		self.prev_content_id = 0
		# Add itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		self.itemtype = 1
		self.relocate_first_item
	end

	def create_text
		self.prev_content_id = 0
		# Add itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		self.itemtype = 2
		self.relocate_first_item
	end

	def create_link
		self.prev_content_id = 0
		# Add itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		self.itemtype = 3
		self.parse_html
		self.url_html = nil
		self.relocate_first_item
	end

	def create_image
		self.prev_content_id = 0
		# Add itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		self.itemtype = 4
		self.url = self.remote_image_url if self.remote_image_url
		self.relocate_first_item
	end

	def create_video
		self.prev_content_id = 0
		# Add itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		self.itemtype = 5
		self.create_video_html
		self.parse_html
		self.relocate_first_item
	end

	def destroy_with_image
		next_item = self.class.where(prev_content_id: self.id).first
		next_item.prev_content_id = self.prev_content_id if next_item
		self.remove_image!
		self.destroy
		next_item.save if next_item
	end

	def relocate_first_item
		first_item = self.class.where(prev_content_id: 0, list_id: self.list_id).first
		self.save!
		if first_item
			first_item.prev_content_id = self.id
			first_item.save!
		end
	end

	def parse_html
		# Scarpe with Nokogiri
		# Open URL
		html = open(self.url).read

		# Parse with Nokogiri
		parsed_html = Nokogiri::HTML(html)

		# Title
		self.title = parse_html_title(parsed_html)

		# Description and Image
		# Link item only
		if self.itemtype == 3
			self.snippet = parse_html_description(parsed_html)
		end
	end

	def parse_html_image_urls
		# Scarpe with Nokogiri
		# Open URL
		html = open(self.url).read

		# Parse with Nokogiri
		parsed_html = Nokogiri::HTML(html)

		image_urls = Array.new
		# Check open graph meta tag
		og_image = parsed_html.css("meta[property='og:image']").first
		
		if og_image
			image_urls << og_image['content']
			puts(og_image['content'])
		else
			# Read all img tags in html
			# Exclude very small size images
			images = parsed_html.css('img')

			if images.present?
				# Check the size with RMagick
				images.each do |image|
					# Checks image src is an absolute url
					uri = URI.parse(image.attributes["src"].value)
					
					url = if uri.absolute?
						uri.to_s
					else
						URI.join(self.url, image.attributes["src"].value).to_s
					end

					begin
						rm_image = Magick::ImageList.new(url)

						if rm_image.columns >= 100 && rm_image.rows >= 100
							image_urls << url
						end
					rescue Exception
						logger.error Exception
					end
				end
			end
		end
		image_urls
	end

	def create_video_html
		self.url_html = self.auto_html(self.url){
			youtube;
			dailymotion;
			google_video;
			vimeo;
			ted;
		}
	end

	def up
		unless self.prev_content_id == 0
			id = self.id
			prev_item = self.class.where(id: self.prev_content_id).first
			next_item = self.class.where(prev_content_id: self.id).first

			self.prev_content_id = prev_item.prev_content_id
			self.save
			prev_item.prev_content_id = self.id
			prev_item.save
			if next_item
				next_item.prev_content_id = prev_item.id
				next_item.save
			end
		end
	end

	def down
		next_item = self.class.where(prev_content_id: self.id).first

		if next_item
			next_next_item = self.class.where(prev_content_id: next_item.id).first

			next_item.prev_content_id = self.prev_content_id
			next_item.save
			self.prev_content_id = next_item.id
			self.save
			if next_next_item
				next_next_item.prev_content_id = self.id
				next_next_item.save
			end
		end
	end

	def ahead
		# TODO:Need to refactor logic
		first_item = self.list.items.where(prev_content_id: 0).first

		if first_item.id == self.prev_content_id
			self.up
		else
			next_item = self.list.items.where(prev_content_id: self.id).first
			prev_item_id = self.prev_content_id

			self.prev_content_id = 0
			self.save
			first_item.prev_content_id = self.id
			first_item.save
			if next_item
				next_item.prev_content_id = prev_item_id
				next_item.save
			end
		end
	end

	def backward
		# TODO:Need to refactor logic
		# Get last element
		last_id = self.id
		while self.list.items.where(prev_content_id: last_id).first
			last_id = self.list.items.where(prev_content_id: last_id).first.id
		end

		prev_item_id = self.prev_content_id
		self.prev_content_id = last_id
		self.save
		next_item = self.list.items.where(prev_content_id: self.id).first
		if next_item
			next_item.prev_content_id = prev_item_id
			next_item.save
		end
	end

	private
	def set_default_value
		# Set empty string to execute Rinku.auto_link
    	self.description  ||= ""
	end

	def parse_html_title(parsed_html)
		# Check open graph meta tag
		og_title = parsed_html.css("meta[property='og:title']").first
		
		if og_title
			og_title['content']
		else
			parsed_html.title
		end
	end

	def parse_html_description(parsed_html)
		# Check open graph meta tag
		og_description = parsed_html.css("meta[property='og:description']").first
		
		if og_description
			og_description['content']
		else
			# snippet
			meta_desc = parsed_html.css("meta[name='description']").first
			meta_desc['content'] if meta_desc
		end
	end
end