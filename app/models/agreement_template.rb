class AgreementTemplate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name, type: String
  field :active, type: Boolean, default: false
  field :agreement_type, type: String
  field :client_agreement_valid_til, type: Boolean, default: false
  field :agreement_expiration_date, type: String

  field :client_agreement_valid_for, type: Boolean, default: false
  field :valid_for_integer, type: String
  field :valid_for_interval, type: String 

  mount_uploader :agreement_doc , AgreementTemplateUploader

end
