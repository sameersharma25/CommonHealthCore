class Appointment
  include Mongoid::Document
  field :date_of_appointment, type: String
  field :reason_for_visit, type: String
  field :status, type: String
  field :service_provider_id, type: Integer
  field :cc_id, type: String

  field :last_notified, type: String


  belongs_to :client_application
  belongs_to :patient
  belongs_to :user
end
