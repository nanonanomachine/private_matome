class ListsController < ApplicationController
	load_resource :group,:only => [:new, :create]
	load_and_authorize_resource :list, :through => :group, :shallow => true
	before_filter :authenticate_user!, except: :show
	
	def index
	end

	def new
		@list = List.new
	end

	def show
		# Order items
		@sort_items = @list.sort_items
	end

	def create
		@list = current_user.lists.build(list_params)
		@list.group = @group
		# First creation sets as draft
		@list.draft_flag = true

		if @list.save
			redirect_to @list
		else
			render 'new'
		end
	end

	def edit
		# Order items
		@sort_items = @list.sort_items
	end

	def update
		unless @list.update_attributes(list_params)
			redirect_to @list, flash: { error: "Update Fail"}
		end
	end

	def destroy
		@list.destroy
		redirect_to group_path(@group)
	end

	def list_params
		params.require(:list).permit(:title, :description, :image, :remote_image_url)
	end
end
