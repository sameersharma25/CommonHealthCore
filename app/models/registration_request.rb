class RegistrationRequest
  include Mongoid::Document

  field :application_name, type: String
  field :application_url, type: String
  field :user_email, type: String
  field :invited, type: Boolean, default: false
  field :invitation_accepted, type: Boolean, default: false
  field :external_application, type: Boolean, default: false
  field :active, type: Boolean, default: false

  validates :application_name, uniqueness: true
  validates_presence_of :application_name, :application_url, :user_email
  validate :email_already_taken

  def email_already_taken
    all_email = User.all.pluck(:email)
    Rails.logger.debug("IN THE RR MODEL")
    if all_email.include?(user_email)
      errors.add(:user_email, "is already taken, please choose a different email.")
    end
  end

end
