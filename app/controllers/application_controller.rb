class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :authenticate_user_from_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_admin_user_from_token
  before_action :set_current_user

  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end

  #private

  # def token
  #   value = request.headers["Authorization"]
  #   return if value.blank?
  #   # @token ||= JWT.decode(value, Rails.application.secrets.jwt_secret, true, { algorithm: 'HS256' }).first
  #   @token = value
  # end

  # def default_url_options
  #   logger
  #   { email: current_user.email , "user-token" => current_user.authentication_token } if !current_user.nil?
  #
  # end

  def set_current_user
    User.current = current_user
    logger.debug("--------in the application controller #{current_user}")
  end



  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    # 'http://www.google.com'
    ENV["APPLICATION_URL"]
  end
end
