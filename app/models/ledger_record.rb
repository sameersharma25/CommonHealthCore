class LedgerRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :referred_application_id, type: String
  field :referred_change_type, type: String
  field :referred_application_object_id, type: String
  field :referred_application_object_type, type: String
  field :changed_fields, type: Hash

  belongs_to :ledger_status

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
