module Api
  # class InvitationsController < Devise::InvitationsController
  class InvitationsController < ActionController::Base
    # protect_from_forgery with: :null_session
    # protect_from_forgery with: :exception, prepend: true
    # protect_from_forgery except: :update
    # skip_before_action :verify_authenticity_token
    # include UsersHelper
    # before_action :authenticate_user_from_token, except: [:update]

    def update
      logger.debug("API Invitaion Controller UPDATE METHOD************************* #{params[:email]}")
      # user = User.find_by(email: params[:user][:email])
      # logger.debug("API Invitaion Controller UPDATE METHOD************************* #{params[:password]}")
      if params[:password] == params[:password_confirmation]
        user = User.find_by(email: params[:email])
        user.invitation_accepted_at = Time.now
        user.invitation_token = nil
        user.password = params[:password]
        user.encrypted_password
        user.save
        render :json => {status: :ok, message: "Password is set" }
      else
        render :json => {status: :ok, message: "Password and Confirm Password does not match" }
      end

      logger.debug("user invitaion token should be nill : #{user.invitation_token}")
      # if user.sign_in_count.to_s == "0"
      #   super
      #   logger.debug("InvitationController redirecting to steps****")
      #   redirect_to after_signup_path(:update_details_and_add_users, email: params[:user][:email]) and return
      # end
      # super
      # raw_invitation_token = update_resource_params[:invitation_token]
      # self.resource = accept_resource
      # invitation_accepted = resource.errors.empty?
      #
      # yield resource if block_given?
      #
      # if invitation_accepted
      #   if Devise.allow_insecure_sign_in_after_accept
      #     logger.debug("in the first if******")
      #     flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      #     set_flash_message :notice, flash_message if is_flashing_format?
      #     # sign_in(resource_name, resource)
      #     # respond_with resource, :location => after_accept_path_for(resource)
      #     redirect_to "http://localhost:4200"
      #   else
      #     logger.debug("in the first else******")
      #     set_flash_message :notice, :updated_not_active if is_flashing_format?
      #     respond_with resource, :location => new_session_path(resource_name)
      #   end
      # else
      #   logger.debug("in the second else******")
      #   resource.invitation_token = raw_invitation_token
      #   respond_with_navigational(resource){ render :edit }
      # end
    end

    def password

      logger.debug("***************** In the Password")

    end
  end
end