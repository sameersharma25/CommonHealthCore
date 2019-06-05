class Interview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :caller_first_name, type: String
  field :caller_last_name, type: String
  field :caller_dob, type: Date
  field :caller_address, type: String
  field :caller_zipcode, type: String
  field :caller_state, type: String
  field :caller_additional_fields, type: Hash


  has_many :needs
  belongs_to :client_application

end
