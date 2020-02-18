class AlertParentAppMailer < ApplicationMailer

	#mailer{ ReferralPartner, AssignedProvider, Description, Patient}
	def taskReassigned(referralPartner, assignedProvider, description, datient)

			@referralPartner = referralPartner
				logger.debug("1::#{@referralPartner}")
			@patient = patient
				logger.debug("2::#{@patient}")
			@assignedProvider = assignedProvider
				logger.debug("3::#{@assignedProvider}")
			@descrription = description
				logger.debug("4::#{@descrription}")

    		mail(to: referralPartner.email, subject: "Unable to provide service for patient")
	end 
end
