class PocMailer < ApplicationMailer
default from: "test@example.com"
  def poc_welcome(email)

    logger.debug("INSIDE THE MAILER : #{email.inspect}")
    mail(to: email, subject: "Provider Registeration with Common Health Core")
  end
end
