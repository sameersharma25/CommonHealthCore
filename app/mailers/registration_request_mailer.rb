class RegistrationRequestMailer < ActionMailer::Base
  default from: "test@example.com"
  def registation_request(rr)
    @request = rr
    logger.debug("INSIDE THE MAILER : #{rr.inspect}")
    mail(to: rr.user_email, subject: "Requestion Application Registration")
  end

end