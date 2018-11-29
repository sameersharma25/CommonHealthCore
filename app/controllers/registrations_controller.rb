class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  # def new
  #   super
  #   logger.debug("RegistrationsController-new**************")
  #   after_signup_path(:update_details_and_add_users)
  # end
  #
  # def disclaimer
  #   logger.debug("user_steps-disclaimers!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  #   respond_to do |format|
  #     format.html
  #   end
  # end

  def create
    # super
    logger.debug("RegistrationsController-create**************")
    # email = params["user"]["email"]
    # user = User.find_by(email: email)
    #
    # user.password = params["user"]["password"]
    # user.encrypted_password
    # user.save

    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
    after_signup_path(:role)
  end



  # def create
  #   build_resource(sign_up_params)
  #   logger.debug("the RESOURCE IS #{resource.inspect}")
  #   user = User.find_by(email: params["user"]["email"])
  #   resource.save
  #   # yield resource if block_given?
  #   if resource.persisted?
  #     logger.debug("RegistrationsController-create************** persisted")
  #     if resource.active_for_authentication?
  #       logger.debug("RegistrationsController-create************** persist if")
  #       set_flash_message! :notice, :signed_up
  #       sign_up(resource_name, resource)
  #       respond_with resource, location: after_sign_up_path_for(resource)
  #     else
  #       logger.debug("RegistrationsController-create************** persist else")
  #       set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
  #       expire_data_after_sign_in!
  #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
  #     end
  #   else
  #     logger.debug("RegistrationsController-create************** NOT persist")
  #     clean_up_passwords resource
  #     set_minimum_password_length
  #     # respond_with resource
  #     after_signup_path(:update_details_and_add_users)
  #   end
  # end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  #   # params.require(:client_application).permit(:name, :application_url,:id,:email, users_attributes: [:id,:name, :email, :_destroy])
  end

  def after_sign_up_path_for(resource)
    logger.debug("*****************registration----after_sign_up_path_for*************")
    # current_user.api_token = Digest::SHA1.hexdigest(current_user.email+ Time.now.to_s + rand(100000).to_s)
    # current_user.save
    after_signup_path(:role)
  end
  #
  # def check_captcha
  #   unless verify_recaptcha
  #     self.resource = resource_class.new sign_up_params
  #     resource.validate # Look for any other validation errors besides Recaptcha
  #     respond_with_navigational(resource) { render :new }
  #   end
  # end
end
