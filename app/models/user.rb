class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable


  devise :two_factor_authenticatable, :two_factor_backupable, :otp_secret_encryption_key => Rails.application.secrets.otp_key
    # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  validate :password_complexity

  ## Token Authenticatable
  acts_as_token_authenticatable
  field :authentication_token

  #two Factor stuff 
  field :otp_backup_codes, type: Array, default: []
            #testing active_otp
  field :active_otp , type: String, default: ""
  field :encrypted_otp_secret , type: String, default: ""
  field :encrypted_otp_secret_iv , type: String, default: ""
  field :encrypted_otp_secret_salt , type: String, default: ""
  
  field :consumed_timestep , type: Integer, default:  0
  field :otp_required_for_login , type: Boolean, default: false
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :phone_number,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer

  index( {invitation_token: 1}, {:background => true} )
  index( {invitation_by_id: 1}, {:background => true} )

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  field :name, type: String
  field :client_application , type: String
  field :admin, type: Boolean
  field :application_representative, type: Boolean
  field :cc, type: Boolean
  field :pcp, type: Boolean
  field :service_provider_id, type: Integer
  field :active, type: Boolean, default: true

  field :roles, type: Array, default: []

  ##chcAuth
  field :tempToken , type: String
 
  

  belongs_to :client_application, inverse_of: :users
  has_many :appointments
  # belongs_to :role

  before_save :add_modifier

  track_history   :on => [:all],       # track title and body fields only, default is :all
                  :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier, set to nil to not create modifier_field
                  :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
                  :modifier_field_optional => true, # marks the modifier relationship as optional (requires Mongoid 6 or higher)
                  :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  :track_create  => true,       # track document creation, default is true
                  :track_update  => true,       # track document updates, default is true
                  :track_destroy => true        # track document destruction, default is true

  def encrypted_otp_secret
    self[:encrypted_otp_secret]
  end

  def encrypted_otp_secret_iv
    self[:encrypted_otp_secret_iv]
  end

  def encrypted_otp_secret_salt
    self[:encrypted_otp_secret_salt]
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data["name"],
    #        email: data["email"],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end

  def otp_qr_code
    issuer = 'CommonHealthCore'
    label = "#{issuer}:#{email}"
    qrcode = RQRCode::QRCode.new(otp_provisioning_uri(label, issuer: issuer))
    qrcode.as_svg(module_size: 4)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end

  def add_modifier
    if !User.current.nil?
      self.modifier_id = User.current.id.to_s
    end
  end

end
