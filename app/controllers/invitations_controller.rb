class InvitationsController < Devise::InvitationsController
  prepend_before_action :require_no_authentication, :only => [ :destroy]
  # after_invitation_accepted :send_to_steps
  def create
    logger.debug "Invitation Controller create method "


  end

  def update
    logger.debug("Invitaion Controller UPDATE METHOD************************* #{params.inspect}")
    user = User.find_by(email: params[:user][:email])
    logger.debug("Invitaion Controller UPDATE METHOD************************* #{user.sign_in_count}")
    # if user.sign_in_count.to_s == "0"
    #   super
    #   logger.debug("InvitationController redirecting to steps****")
    #   redirect_to after_signup_path(:update_details_and_add_users, email: params[:user][:email]) and return
    # end
    super
  end

  # def after_accept_path_for
  #   logger.debug("Invitaion Controller  after_accept_path_for   METHOD*************************" )
  #   redirect_to after_signup_path(:update_details_and_add_users)
  # end

  def after_invite_path_for(resource)
    logger.debug("Invitaion Controller  after_accept_path_for   METHOD*************************" )
    after_signup_path(:update_details_and_add_users)
  end

end