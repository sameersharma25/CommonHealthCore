class InvitationsController < Devise::InvitationsController
  prepend_before_action :require_no_authentication, :only => [ :update,:destroy]
  # after_invitation_accepted :send_to_steps
  # def create
  #   logger.debug "Invitation Controller create method "
  #
  #
  # end

  # def edit
  #   logger.debug("invitation edit***** #{params.inspect}")
  #   logger.debug("the email is ************* #{resource.email}********************")
  #
  #   sign_out send("current_#{resource_name}") if send("#{resource_name}_signed_in?")
  #   set_minimum_password_length
  #   resource.invitation_token = params[:invitation_token]
  #   redirect_to "http://localhost:4200/invitation?invitation_token=#{params[:invitation_token]}&&user_email=#{resource.email}"
  # end



  # def update
  #   # logger.debug("Invitaion Controller UPDATE METHOD************************* #{params.inspect}")
  #   # user = User.find_by(email: params[:user][:email])
  #   # logger.debug("Invitaion Controller UPDATE METHOD************************* #{user.sign_in_count}")
  #   # if user.sign_in_count.to_s == "0"
  #   #   super
  #   #   logger.debug("InvitationController redirecting to steps****")
  #   #   redirect_to after_signup_path(:update_details_and_add_users, email: params[:user][:email]) and return
  #   # end
  #   # super
  #   raw_invitation_token = update_resource_params[:invitation_token]
  #   self.resource = accept_resource
  #   invitation_accepted = resource.errors.empty?
  #
  #   logger.debug("invitation_accepted is : #{invitation_accepted.inspect}")
  #   logger.debug("errors in resources are : #{resource.errors.inspect}")
  #   logger.debug("errors in resources are : #{resource.inspect}")
  #
  #
  #   yield resource if block_given?
  #
  #   if invitation_accepted
  #     if Devise.allow_insecure_sign_in_after_accept
  #       logger.debug("in the first if******")
  #       flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
  #       set_flash_message :notice, flash_message if is_flashing_format?
  #       # sign_in(resource_name, resource)
  #       # respond_with resource, :location => after_accept_path_for(resource)
  #       redirect_to "https://dev8.resourcestack.com"
  #     else
  #       logger.debug("in the first else******")
  #       set_flash_message :notice, :updated_not_active if is_flashing_format?
  #       respond_with resource, :location => new_session_path(resource_name)
  #     end
  #   else
  #     logger.debug("in the second else******")
  #     resource.invitation_token = raw_invitation_token
  #     respond_with_navigational(resource){ render :edit }
  #   end
  #   # super do |resource|
  #   #   if resource.errors.empty?
  #   #     render json: { status: "Invitation Accepted!" }, status: 200 and return
  #   #   else
  #   #     render json: resource.errors, status: 401 and return
  #   #   end
  #   # end
  # end

  # def after_accept_path_for
  #   logger.debug("Invitaion Controller  after_accept_path_for   METHOD*************************" )
  #   redirect_to after_signup_path(:update_details_and_add_users)
  # end

  def after_invite_path_for(resource)
    logger.debug("Invitaion Controller  after_accept_path_for   METHOD*************************" )
    after_signup_path(:update_details_and_add_users)
  end

end