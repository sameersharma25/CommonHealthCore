class AlertParentAppMailer < ApplicationMailer

	#mailer{ ReferralPartner, AssignedProvider, Description, Patient}
	def taskReassigned(ReferralPartner, AssignedProvider, Description, Patient)

			@referralPartner = ReferralPartner
				logger.debug("1::#{@referralPartner}")
			@patient = Patient
				logger.debug("2::#{@patient}")
			@assignedProvider = AssignedProvider
				logger.debug("3::#{@assignedProvider}")
			@descrription = Description
				logger.debug("4::#{@descrription}")

    		mail(to: ReferralPartner.email, subject: "Unable to provide service for patient")
	end 
end
