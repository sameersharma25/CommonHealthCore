class Referral
  include Mongoid::Document
  include Mongoid::Timestamps

  field :referral_name, type: String
  field :source, type: String
  field :referral_description, type: String
  field :urgency, type: String
  field :due_date, type: String


  has_many :tasks
  belongs_to :patient
  belongs_to :client_application
end
