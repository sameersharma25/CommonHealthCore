class RegistrationRequestMailer < ActionMailer::Base
  default from: "test@example.com"
  def registation_request(rr)
    @request = rr
    logger.debug("INSIDE THE MAILER : #{rr.inspect}")
    mail(to: rr.user_email, subject: "Requestion Application Registration")
  end

  def referral_request(email,task_id, client_id)
    @task_id = task_id
    @client_id = client_id

    mail(to: email, subject: "Patient Referral")
  end

end