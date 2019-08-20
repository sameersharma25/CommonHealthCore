class ResetPasswordController < ApplicationController


	def reset_password
	    @user = User.all 
	end 

	def reset_password_part_two
	    @person = User.find_by(email: params[:user])

	    @person.send_reset_password_instructions

	    redirect_to client_applications_path 
	end 
end
