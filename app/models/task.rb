class Task
  include Mongoid::Document

  field :task_type, type: String
  field :task_status, type: String
  field :task_owner, type: String
  field :provider , type: String
  field :task_deadline, type: String
  field :task_description, type: String


  belongs_to :referral
  has_many :communications
end
