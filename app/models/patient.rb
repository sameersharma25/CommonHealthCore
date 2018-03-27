class Patient
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :date_of_birth, type: String
  field :patient_email, type: String
  field :patient_phone, type: String
  field :patient_coverage, type: String
  field :patient_address, type: String

  belongs_to :client_application
  has_many :appointments
end
