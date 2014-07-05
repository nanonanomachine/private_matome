module ItemsHelper
	def item_for(item)
		# make template for each item
		# itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		case item.itemtype
		when 1
			item_title_for(item)
		when 2
			item_text_for(item)
		when 3
			item_link_for(item)
		when 4
			item_image_for(item)
		when 5
			item_video_for(item)
		end
	end

	private
	def item_title_for(item)
		render :partial => 'items/item_title', :locals => { item: item }
	end

	def item_text_for(item)
		render :partial => 'items/item_text', :locals => { item: item }
	end

	def item_link_for(item)
		render :partial => 'items/item_link', :locals => { item: item }
	end

	def item_image_for(item)
		render :partial => 'items/item_image', :locals => { item: item }
	end

	def item_video_for(item)
		render :partial => 'items/item_video', :locals => { item: item }
	end
end
