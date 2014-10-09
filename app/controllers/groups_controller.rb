class GroupsController < ApplicationController
	load_and_authorize_resource
	before_filter :authenticate_user!, except: [:show, :index]

	def index
	end

	def new
		@group = Group.new
	end

	def show
	end

	def create
		# Add group
		@group = Group.new(group_params)

		if @group.save
			# Add user relation
			@group.admins << current_user
			redirect_to @group
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @group.update_attributes(group_params)
			redirect_to @group
		else
			render 'edit'
		end
	end

	def destroy
		# Delete user relation
		@group.users.each do |f|
			f.groups.delete(@group)
		end
		# Delete group
		@group.destroy

		redirect_to groups_path
	end

private
  def group_params
    params.require(:group).permit(:name, :description, :link, :privacy)
  end
end