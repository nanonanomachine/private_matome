class ItemsController < ApplicationController
	load_resource :list,  :except => [:index, :show, :destroy, :edit, :update, :up, :down, :ahead, :backward]
	load_and_authorize_resource :item, :new => [:create_link, :create_video], :through => :list, :shallow => true
	before_filter :authenticate_user!

	def index
	end

	def new
		@item = Item.new
	end

	def show
		@item = Item.find(params[:id])
	end

	# Create title
	def create
		create_item_setup
		@item.create_title
		@item_name = item_name(@item)
	end

	# Create text
	def create_text
		create_item_setup
		@item.create_text
	end

	# Create link
	def create_link
		create_item_setup
		@item.create_link
		@item_name = item_name(@item)
	end

	# Create image
	def create_image
		create_item_setup
		@item.create_image
		@item_name = item_name(@item)
	end

	# Create video
	def create_video
		create_item_setup
		@item.create_video
		@item_name = item_name(@item)
	end

	def edit
		# set instance variable for defying partial
		@item_name = item_name(@item)
			
		respond_to do |format|
			format.html { render :layout => false }
			# tell controller to respond to requests with JS format
			format.js
		end
	end

	def update
		unless @item.update_attributes(item_params)
			render 'edit', flash: { error: "Update Fail"}
		end
	end

	def destroy
		@item_id = @item.id
		@item.destroy_with_image
	end

	def up
		@item.up
		redirect_to list_path(@item.list)
	end

	def down
		@item.down
		redirect_to list_path(@item.list)
	end

	def ahead
		@item.ahead
		redirect_to list_path(@item.list)
	end

	def backward
		@item.backward
		redirect_to list_path(@item.list)
	end

	def item_params
		params.require(:item).permit(:list_id, :title, :description, :image, :remote_image_url, :url)
	end

	private

	def create_item_setup
		@item = current_user.items.build(item_params)
		@item.list = @list
	end

	def item_name(item)
		# itemtype, 1:title, 2:text, 3:link, 4:image, 5:video
		case item.itemtype
		when 1
			"title"
		when 2
			"text"
		when 3
			"link"
		when 4
			"image"
		when 5
			"video"
		end
	end
end
