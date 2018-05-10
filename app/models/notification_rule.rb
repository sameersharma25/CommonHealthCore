class NotificationRule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :appointment_status, type: String
  field :time_difference, type: Integer
  field :greater, type: Boolean
  field :subject, type: String
  field :body, type: String
  field :user_type, type: String
  field :notification_type, type: String


  belongs_to :client_application



  def self.selected_rules(a_id ,td_hrs)
    notification_hash = Hash.new

    a = Appointment.find(a_id)
    patient = a.patient
    status = a.status
    patient_email = patient.patient_email
    patient_phone = patient.patient_phone
    patient_name = patient.first_name+" "+patient.last_name
    cc_email = User.find(a.cc_id).email
    pcp_email = "pcp@test.com"

    #puts("the notifications are: #{NotificationRule.where(:time_difference.lt => td_hrs, :appointment_status => "New" ).select{"time_difference"}}")
    notification_array= NotificationRule.where(:time_difference.lt => td_hrs, :appointment_status => "New" ).collect{|nr| nr.time_difference}
    maximum_if_time_difference = notification_array.max
    relevant_notifications = NotificationRule.where(:appointment_status => status, :time_difference => maximum_if_time_difference )

    # puts("BEFORE LOOOOOOOOOPINGGGGGGGg*******************#{relevant_notifications.inspect}")
    relevant_notifications.each do |rn|
      #puts("the notifications are: #{rn.inspect}************************************\n")
      createing_hash =  {"#{rn.user_type}" => {"email" => eval("#{rn.user_type}_email"), "phone" => patient_phone, subject: rn.subject, body: rn.body}}
      notification_hash.update(createing_hash)

      # puts("the notifications are: #{notification_hash}************************************\n")
    end
    return notification_hash
  end


end
