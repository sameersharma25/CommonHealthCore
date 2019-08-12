class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
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
  field :through_call, type: Boolean
  field :caller_additional_fields, type: Hash
  field :security_keys, type: Array

  belongs_to :client_application
  has_many :appointments
  has_many :referrals
  has_many :notes
  has_many :needs
  geocoded_by :patient_zipcode

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
