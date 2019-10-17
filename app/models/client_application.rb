class ClientApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :application_url, type: String
  field :service_provider_url, type: String
  field :external_application, type: Boolean
  field :accept_referrals, type: Boolean
  field :client_speciality, type: String
  field :master_application_status, type: Boolean , default: false
  field :organization_type, type: String
  field :organization_group, type: String
  field :agreement_signed, type: Boolean, default: false
  field :agreement_counter_sign, type: String
  field :agreement_type, type: String
  field :reason_for_agreement_reject, type: String


  field :client_agreement_expiration, type: String
  field :client_agreement_sign_date, type: String  
 
  field :logo, type: String 
  field :theme, type: String
  field :custom_agreement, type: Boolean, default: false 
  field :custom_agreement_comment, type: String 
  mount_uploader :logo, LogoUploader
  mount_uploader :client_agreement , ClientAgreementUploader

  # validates_presence_of :name, :application_url

  has_many :patients
  has_many :appointments
  has_many :notification_rules, inverse_of: :client_application
  has_many :users, inverse_of: :client_application
  has_many :referrals
  has_many :service_provider_details
  has_many :roles
  has_many :statuses
  has_many :external_api_setups
  has_many :interviews
  has_many :question_responses
  has_many :faq
  has_many :about_u
  has_many :terms_privacy
  # has_many :mapped_parameters
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notification_rules, reject_if: :all_blank, allow_destroy: true

  THEME = {
    'red': '#DE0903',
    'orange': '#FE5E00',
    'yellow': '#FFFF00',
    'green': '#348017',
    'blue': '#0000FF',
    'indigo': '#4B0082',
    'violet': '#8D38C9',
    'black': '#000000',
    'grey': '#666362'
  }

  def humanized_theme
    THEME.invert[self.theme]
  end 
end
 