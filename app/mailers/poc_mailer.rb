class PocMailer < ApplicationMailer
default from: "test@example.com"
  def poc_welcome(email)

    logger.debug("INSIDE THE MAILER : #{email.inspect}")
    mail(to: email, subject: "Entry in the Common Health Core provider directory")
  end
end
