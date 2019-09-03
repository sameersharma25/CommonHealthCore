class Users::SessionsController < Devise::SessionsController


  def pre_otp
    user = User.find_by pre_otp_params
    @two_factor_enabled = user && user.otp_required_for_login
    #user.otp_secret = User.generate_otp_secret
    #user.save!
    dundun = user.current_otp

    logger.debug("LETS GO #{dundun}")

    respond_to do |format|
      format.js
      logger.debug("Look here #{dundun}")
    end
    

  end

  private

  def pre_otp_params
    params.require(:user).permit(:email)
  end
end