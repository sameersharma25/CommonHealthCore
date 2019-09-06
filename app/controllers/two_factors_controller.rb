class TwoFactorsController < ApplicationController
	before_action :authenticate_user!

	def create
		@codes = current_user.generate_otp_backup_codes!
		current_user.update(
			otp_required_for_login: true,
			otp_secret: User.generate_otp_secret,
		)
	end 
  
	def destroy
		current_user.update(
			otp_required_for_login: false
		)
	end 
end
