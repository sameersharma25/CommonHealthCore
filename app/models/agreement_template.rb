class AgreementTemplate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name, type: String
  field :active, type: Boolean, default: false
  field :agreement_type, type: String

  mount_uploader :agreement_doc , AgreementTemplateUploader
end
