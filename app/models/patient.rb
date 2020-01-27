class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  include Mongoid::History::Trackable
  # include Geocoder::Model::MongoMapper

  # json {firstName: first_name, lastNname: last_name}

  field :first_name, type: String
  field :last_name, type: String
  field :date_of_birth, type: String
  field :patient_email, type: String
  field :patient_phone, type: String
  field :patient_coverage_id, type: String
  field :healthcare_coverage, type: String
  field :patient_address, type: String
  field :mode_of_contact, type: String
  field :patient_zipcode, type: String
  field :patient_state, type: String
  field :patient_status, type: String
  field :gender, type: String
  field :race, type: String
  field :ethnicity, type: String
  field :security_keys, type: Array, default: []
  field :through_call, type: Boolean
  field :caller_additional_fields, type: Hash
  #
  field :primary_care_physician, type: String
  field :emergency_contact_fName, type: String
  field :emergency_contact_lName, type: String
  field :emergency_contact_phone, type: String
  field :emergency_contact_email, type: String
  field :emergency_contact_relationship, type: String 
  
  field :population_group, type: Array, default: []
  field :service_group, type: Array, default: []
  field :client_consent, type: Boolean
  field :patient_created_by, type: String


  belongs_to :client_application
  has_many :appointments
  has_many :referrals
  has_many :notes
  has_many :needs
  geocoded_by :patient_zipcode

  # track_history   :on => [:first_name, :last_name]
  track_history   :on => [:all],       # track title and body fields only, default is :all
                  :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier, set to nil to not create modifier_field
                  :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
                  :modifier_field_optional => true, # marks the modifier relationship as optional (requires Mongoid 6 or higher)
                  :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  :track_create  => true,       # track document creation, default is true
                  :track_update  => true,       # track document updates, default is true
                  :track_destroy => true        # track document destruction, default is true

  def self.update_patient_status

    ap = Patient.all

    ap.each do |p|
      appointment_count = p.appointments.count
      if appointment_count == 0
        p.patient_status = "New"
      elsif appointment_count == 1
        if p.appointments[0][:status] == "Completed"
          p.patient_status = "Treated"
        elsif p.appointments[0][:status] == "Scheduled"
          p.patient_status = "Scheduled"
        else
          p.patient_status = "Contacted"
        end
      elsif appointment_count > 1
        if p.appointments.collect{|a| a.status}.uniq.include?("Schedule")
          p.patient_status = "Scheduled"
        elsif p.appointments.collect{|a| a.status}.uniq.include?("New") || p.appointments.collect{|a| a.status}.uniq.include?("Edit")
          p.patient_status = "Contacted"
        else
          p.patient_status = "Treated"
        end
      end
      p.save
    end
  end

  def self.entries_count
    p = Patient.all.count
    a = Appointment.all.count
    puts("Patients Count: #{p} , Appointment Count: #{a}")
  end

end
