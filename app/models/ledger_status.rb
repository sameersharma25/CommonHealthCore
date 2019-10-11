class LedgerStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  field :referred_application_id, type: String
  field :ledger_status, type: String
  field :external_object_id, type: String
  field :referred_by_id, type: String
  field :request_reject_reason, type: String

  belongs_to :ledger_master
  has_many :ledger_records


end
