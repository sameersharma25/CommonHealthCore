class Obstacle
  include Mongoid::Document
  include Mongoid::Timestamps

  field :obstacle_title, type: String
  field :obstacle_description, type: String
  field :obstacle_notes, type: String
  field :obstacle_urgency, type: String
  field :obstacle_status, type: String

  belongs_to :need
  has_many :solutions

end
