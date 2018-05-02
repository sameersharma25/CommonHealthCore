class NotificationRule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject, type: String
  field :body, type: String
  field :notification_type, type: String
  field :appointment_status, type: String
  field :appointment_time_passed, type: String
  belongs_to :client_application

end
