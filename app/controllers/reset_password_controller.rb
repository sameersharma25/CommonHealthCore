class ResetPasswordController < ApplicationController



	def reset_password
	    @user = User.all 
	end 

	def reset_password_part_two
		logger.debug("params #{params}")
	    @person = User.find_by(email: params[:email])

	    @person.send_reset_password_instructions

	    redirect_to client_applications_path 
	end 

end
