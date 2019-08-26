class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end


  # def current_user
  #   logger.debug("in the applicaiton controller ***************")
  #   # @current_user ||= User.find_by(email: params["email"])
  #   if token
  #     @current_user ||= User.find_by(email: params["email"])
  #   end
  # end

  private

  # def token
  #   value = request.headers["Authorization"]
  #   return if value.blank?
  #   # @token ||= JWT.decode(value, Rails.application.secrets.jwt_secret, true, { algorithm: 'HS256' }).first
  #   @token = value
  # end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end
end
