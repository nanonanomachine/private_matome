class UsersController < ApplicationController
	load_resource :group, :only => [:index]
	before_filter :authenticate_user!
	# layout "devise"
	
	def index
	end

	def edit
		@user = current_user
	end

	def update_avatar
		@user = current_user
		@user.update(user_params)
		redirect_to edit_user_registration_path(id:@user.id)
	 end

	def password
		@user = current_user
	end

	def update_password
		@user = current_user
		if @user.update(user_params)
			# Sign in the user by passing validation in case his password changed
			sign_in @user, :bypass => true
			redirect_to root_path
		else
			render "edit"
		end
	end

	def show
		@user = User.find(params[:id])
	end

	def user_params
		params.required(:user).permit(:password, :password_confirmation, :avatar)
	end
end
