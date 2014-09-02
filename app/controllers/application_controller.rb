class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def require_admin
  	if current_user.is_admin?
  		return true
  	else
  		render_500("Not Authorized Admin")
  		return false
  	end
  end

  # Exception Handling
  # 404 : RoutingError, RecordNotFound
  # 500 : Other
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, :with => :render_404 if Rails.env.production?
  rescue_from Exception, :with => :render_500 if Rails.env.production?

  # Write log and Render #{Rails.root}/public/500.html
  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end

    render :file => "#{Rails.root}/public/500.html", :status => 500, :layout => false, :content_type => 'text/html'
  end

  # Write log and Render #{Rails.root}/public/404.html
  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => 'text/html'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end
end