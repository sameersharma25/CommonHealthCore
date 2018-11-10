class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: String


  belongs_to :client_application


end
