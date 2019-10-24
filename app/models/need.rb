class Need
  include Mongoid::Document
  include Mongoid::Timestamps

  field :need_title, type: String
  field :need_description, type: String
  field :need_notes, type: String
  field :need_urgency, type: String
  field :need_status, type: String


  has_many :obstacles
  # belongs_to :interview
  belongs_to :patient
  belongs_to :referral
end
