class TwoFactorMailer < ApplicationMailer
	default from: "test@example.com"

	def sendOTP(otp, email)
	mail(to: email, subject: "Your OTP: #{otp}")

	end 
end
