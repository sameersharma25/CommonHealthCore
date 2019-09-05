class User
  include Mongoid::Document

  devise :two_factor_authenticatable, :two_factor_backupable, :otp_secret_encryption_key => Rails.application.secrets.otp_key
    # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  ## Token Authenticatable
  acts_as_token_authenticatable
  field :authentication_token

  #two Factor stuff 
  field :otp_backup_codes, type: Array, default: []

  field :encrypted_otp_secret , type: String, default: ""
  field :encrypted_otp_secret_iv , type: String, default: ""
  field :encrypted_otp_secret_salt , type: String, default: ""
  
  field :consumed_timestep , type: Integer, default:  0
  field :otp_required_for_login , type: Boolean, default: false
  ## Database authenticatable
  field :email,              type: String, default: ""
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
  field :active, type: Boolean, default: trust

  field :roles, type: Array, default: []

  belongs_to :client_application, inverse_of: :users
  has_many :appointments
  # belongs_to :role

  def encrypted_otp_secret
    self[:encrypted_otp_secret]
  end

  def encrypted_otp_secret_iv
    self[:encrypted_otp_secret_iv]
  end

  def encrypted_otp_secret_salt
    self[:encrypted_otp_secret_salt]
  end

  def otp_code
    puts current_otp
  end 
  
  def otp_qr_code
    issuer = 'CommonHealthCore'
    label = "#{issuer}:#{email}"
    qrcode = RQRCode::QRCode.new(otp_provisioning_uri(label, issuer: issuer))
    qrcode.as_svg(module_size: 4)
  end
end
