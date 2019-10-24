class Referral
  include Mongoid::Document
  include Mongoid::Timestamps

  field :referral_name, type: String
  field :source, type: String
  field :referral_description, type: String
  field :urgency, type: String
  field :due_date, type: String
  field :status, type: String
  field :follow_up_date, type: String 
  field :agreement_notification_flag, type: Boolean
  #
  field :client_consent, type: Boolean, default: false
  field :third_party_user_id, type: String
  field :consent_timestamp, type: String
  field :referral_type, type: String

  has_many :tasks
  has_many :needs
  belongs_to :patient
  belongs_to :client_application
end
