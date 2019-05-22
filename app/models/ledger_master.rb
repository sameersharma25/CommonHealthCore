class LedgerMaster
  include Mongoid::Document
  include Mongoid::Timestamps

  field :task_id, type: String
  field :patient_id, type: String
  field :ledger_master_status, type: String
  field :org_id, type: String


  has_many :ledger_statuses
end
