class NotificationMailer < ApplicationMailer

		#mailer{ ReferralPartner, AssignedProvider, Description, Patient}
	def taskReassigned(referralPartner, assignedProvider, description, patient)

			@referralPartner = referralPartner
				logger.debug("1::#{@referralPartner}")
			@patient = patient
				logger.debug("2::#{@patient}")
			@assignedProvider = assignedProvider
				logger.debug("3::#{@assignedProvider}")
			@descrription = description
				logger.debug("4::#{@descrription}")

    		mail(to: @referralPartner.email, subject: "Unable to provide service for patient")
	end 
		#mailer { status, task, clientApp } #user task.description
	def alertParentAppStatusDecline(task, ca)
		@task = task
		logger.debug("the task is #{@task.inspect}")
		@ca = ca
		logger.debug("The Origin Client App is #{@ca.email}")
		
		mail(to: @ca.email, subject: "Task transfer has been declined")
	end 

	def alertParentAppStatusAccept(task, ca)
		@task = task
		logger.debug("the task is #{@task.inspect}")
		@ca = ca
		logger.debug("The Origin Client App is #{@ca.email}")
		
		mail(to: @ca.email, subject: "Task transfer has been accepted")
	end 

	def alertPendingContactJoined(user, adminUser)
			@user = user
			logger.debug("pending user was #{@user}")
			@userAdmin = userAdmin
			logger.debug("pending user ADMIN is #{@userAdmin}")
			#NotificationMailer.AlertPendingContactJoined(user, adminUser).deliver
			mail(to: @adminUser.email, subject: "A pending contact has joined")
	end 
end
