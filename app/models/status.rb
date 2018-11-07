class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status


  belongs_to :client_application


end
