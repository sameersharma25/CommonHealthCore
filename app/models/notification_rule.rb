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


  belongs_to :client_application, inverse_of: :notification_rules



  def self.selected_rules(t_id ,td_hrs)
    notification_hash = Hash.new

    # a = Appointment.find(a_id)
    # patient = a.patient
    # status = a.status
    # patient_email = patient.patient_email
    # patient_phone = patient.patient_phone
    # patient_name = patient.first_name+" "+patient.last_name
    # cc_email = User.find(a.cc_id).email
    # pcp_email = "pcp@test.com"

    t = Task.find(t_id)
    task_status = t.task_status
    patient = t.referral.patient
    patient_email = patient.patient_email
    patient_phone = patient.patient_phone
    patient_name = patient.first_name+" "+patient.last_name
    cc_email = User.find(t.task_owner).email
    pcp_email = "pcp@test.com"
    task_owner_email = User.find(t.task_owner).email




    #puts("the notifications are: #{NotificationRule.where(:time_difference.lt => td_hrs, :appointment_status => "New" ).select{"time_difference"}}")
    # notification_array= NotificationRule.where(:time_difference.lt => td_hrs, :appointment_status => status ).collect{|nr| nr.time_difference}
    # maximum_if_time_difference = notification_array.max
    status = Status.find_by(status: task_status).status
    relevant_notifications = NotificationRule.where(:appointment_status => status, :time_difference => td_hrs )

    puts("BEFORE LOOOOOOOOOPINGGGGGGGg*******************#{relevant_notifications.entries}........... time is : #{td_hrs}, TASK IS : #{t_id}")
    relevant_notifications.each do |rn|
      if rn.user_type == "Owner"
        createing_hash =  {"#{rn.user_type}" => {"email" => task_owner_email, subject: rn.subject, body: rn.body}}

      elsif rn.user_type == "Patient"
        createing_hash =  {"#{rn.user_type}" => {"email" => patient_email, "phone" => patient_phone, subject: rn.subject, body: rn.body}}
      elsif rn.user_type == "Service Provider"

      elsif rn.user_type == "All"
        all_hash = Hash.new
        [{"Patient" => patient_email}, {"Owner" => task_owner_email}].each do |l|
          l.each do |key, val|
            if key == "Patient"
              partial_hash =  {"#{key}" => {"email" => val, "phone" => patient_phone, subject: rn.subject, body: rn.body}}
            elsif key == "Owner"
              partial_hash =  {"#{key}" => {"email" => val, subject: rn.subject, body: rn.body}}
            end

            all_hash.update(partial_hash)
          end
        end
        createing_hash = all_hash
      end

      #puts("the notifications are: #{rn.inspect}************************************\n")
      # createing_hash =  {"#{rn.user_type}" => {"email" => eval("#{rn.user_type}_email"), "phone" => patient_phone, "patient_email" => patient_email, subject: rn.subject, body: rn.body}}
      notification_hash.update(createing_hash)

      # puts("the notifications are: #{notification_hash}************************************\n")
    end
    # notification_hash.update(createing_hash)
    return notification_hash
  end


end
