class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: Hash
  field :active, type: Boolean


  belongs_to :appointment


end
