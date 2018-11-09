class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable

  field :status
  field :title, type: String
  field :manual, type: Boolean
  field :position, type: Integer 
  field :status_id, type: Integer

  belongs_to :client_application



end
