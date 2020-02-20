class Referral
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :referral_name, type: String
  field :source, type: String
  field :referral_description, type: String
  field :urgency, type: String
  field :due_date, type: String
  field :status, type: String
  field :follow_up_date, type: String 
  field :agreement_notification_flag, type: Boolean
  #
  field :client_consent, type: Boolean, default: false
  field :third_party_user_id, type: String
  field :consent_timestamp, type: String
  field :referral_type, type: String
  field :ref_created_by, type: String
  field :transferred_referral, type: Boolean, default: false

  has_many :tasks
  has_many :needs
  belongs_to :patient
  belongs_to :client_application

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
