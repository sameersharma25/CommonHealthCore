class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  field :first_name, type: String
  field :last_name, type: String
  field :date_of_birth, type: String
  field :patient_email, type: String
  field :patient_phone, type: String
  field :patient_coverage_id, type: String
  field :healthcare_coverage, type: String
  field :patient_address, type: String
  field :mode_of_contact, type: String
  field :patient_zipcode, type: String

  belongs_to :client_application
  has_many :appointments
end
