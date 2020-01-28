class LedgerMaster
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :task_id, type: String
  field :patient_id, type: String
  field :ledger_master_status, type: String
  field :org_id, type: String


  has_many :ledger_statuses

  track_history   :on => [:all],       # track title and body fields only, default is :all
                  :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier, set to nil to not create modifier_field
                  :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
                  :modifier_field_optional => true, # marks the modifier relationship as optional (requires Mongoid 6 or higher)
                  :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  :track_create  => true,       # track document creation, default is true
                  :track_update  => true,       # track document updates, default is true
                  :track_destroy => true        # track document destruction, default is true
  before_save :add_modifier

  def add_modifier
    # Rails.logger.debug("in the USER in patient model -------- #{User.current.inspect}")
    self.modifier_id = User.current.id.to_s
  end
end
