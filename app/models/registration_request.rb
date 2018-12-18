class RegistrationRequest
  include Mongoid::Document

  field :application_name, type: String
  field :application_url, type: String
  field :user_email, type: String
  field :invited, type: Boolean, default: false

  validates_presence_of :application_name, :application_url, :user_email

end
