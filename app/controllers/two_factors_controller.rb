class TwoFactorsController < ApplicationController
	before_action :authenticate_user!

	def create
		@codes = current_user.generate_otp_backup_codes!
		current_user.update(
			otp_required_for_login: true,
			otp_secret: User.generate_otp_secret,
			encrypted_otp_secret: User.encrypted_otp_secret,
			encrypted_otp_secret_iv: User.encrypted_otp_secret_iv,
			encrypted_otp_secret_salt: User.encrypted_otp_secret_salt
		)

	end 


	def destroy
		current_user.update(
			otp_required_for_login: false
		)
	end 
end
