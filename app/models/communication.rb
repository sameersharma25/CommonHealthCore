class Communication
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sender_id, type: String
  field :recipient_id, type: String
  field :recipient_type, type: String
  field :comm_subject, type: String
  field :comm_message, type: String
  field :comm_type, type: String


  belongs_to :task
end
se