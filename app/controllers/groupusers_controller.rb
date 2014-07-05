class GroupusersController < ApplicationController
	load_resource :group
	load_resource :user
	before_filter :authenticate_user!

	def add
		authorize! :add, @group
		@group.members << @user
		redirect_to @group
	end

	def assign_admin
		authorize! :assign_admin, @group
		usergroup = UserGroup.where(group: @group, user: @user).first
		usergroup.update_attributes(role: 'admin') if usergroup
		redirect_to controller: 'users', action:'index'
	end

	def assign_moderator
		authorize! :assign_moderator, @group
		usergroup = UserGroup.where(group: @group, user: @user).first
		usergroup.update_attributes(role: 'moderator') if usergroup
		redirect_to controller: 'users', action:'index'
	end

	def assign_member
		authorize! :assign_member, @group
		usergroup = UserGroup.where(group: @group, user: @user).first
		usergroup.update_attributes(role: 'member') if usergroup
		redirect_to controller: 'users', action:'index'
	end

	def destroy
		authorize! :destroy, @group
		@group.users.delete(@user)
		redirect_to controller: 'users', action:'index'
	end
end
