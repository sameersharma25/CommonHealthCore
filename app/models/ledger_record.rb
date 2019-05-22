class LedgerRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :referred_application_id, type: String
  field :referred_change_type, type: String
  field :referred_application_object_id, type: String
  field :referred_application_object_type, type: String

  belongs_to :ledger_status

end
