class SendPatientTaskMailer < ApplicationMailer
	default from: "test@example.com"
  def patient_not_sent(email)

    logger.debug("INSIDE THE MAILER : #{email.inspect}")
    mail(to: email, subject: "Patient/Task was not sent")
  end
end
