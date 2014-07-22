class Item < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :list
	mount_uploader :image, ImageUploader

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
		self.save
		if first_item
			first_item.prev_content_id = self.id
			first_item.save
		end
	end

	def parse_html
		# Scarpe with Nokogiri
		# Open URL
		html = open(self.url).read

		# Parse with Nokogiri
		parsed_html = Nokogiri::HTML(html)

		# Title
		self.title = parsed_html.title

		# Description and Image
		# Link item only
		if self.itemtype == 3
			# snippet
			meta_desc = parsed_html.css("meta[name='description']").first
			self.snippet = meta_desc['content'] if meta_desc

			# Images
			# Exclude very small size images
			images = parsed_html.css('img')

			if images.present?
				# Check the size with RMagick
				images.each do |image|
					url = URI.join(self.url, image.attributes["src"].value).to_s
					rm_image = Magick::ImageList.new(url)
					if rm_image.columns >= 100 && rm_image.rows >= 100
						self.remote_image_url = url
						break;
					end
				end
			end
		end
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
end