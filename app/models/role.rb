class Role
  include Mongoid::Document
  include Mongoid::Timestamps

  field :role_name, type: String
  field :role_abilities, type: Array, default: []

  belongs_to :client_application
  # has_many :users
  validates :role_name, presence: true

  def self.get_method_names
    arr = []
    actions = []
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /^[a-z]*$/ #namescoped controllers
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/
            arr << "#{entry.titleize}::#{x.camelize.gsub('.rb', '')}".constantize
          end
        end
        # if entry != "sessions_controller.rb"
        #   # arr << entry.camelize.gsub('.rb', '').constantize
        #   arr << "#{entry.titleize}::#{entry.camelize.gsub('.rb', '')}".constantize
        # end

      end
    end

    method_exceptions = ["authenticate_user_from_token","appointments_referred_to_me","create","create_message_list_hash","create_appointment",
                         "crete_appointment_for_patient", "destroy","get_user_appointments", "give_appointment_details_for_notification",
                         "patient_appointments","password","contact_management_details_for_plugin", "mandatory_parameters_check_after_update",
                          "mandatory_parameters_check","check_mandatory_field"]
    arr.each do |controller|
      puts("the controller is #{controller}")
      controller.action_methods.each do |method|
        # if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
        if !method_exceptions.include?(method)
          actions << method
        end
        # end
      end
    end

    actions
  end
end


#  ClientApplication.all.each do |ca|
#    NotificationRule.where(client_application_id: ca.id.to_s).each do |nr|
#      print("the NOTIFICATION RULE IS: #{nr.id.to_s}")
#      if !nr.appointment_status.nil? && !nr.appointment_status.blank?
#        if nr.appointment_status.length < 20
#          puts("the status are #{Status.where(client_application_id: ca.id.to_s, status: nr.appointment_status).inspect}")
#          status = Status.where(client_application_id: ca.id.to_s, status: nr.appointment_status).first.id.to_s
#          nr.appointment_status = status
#          nr.save
#        end
#      end
#    end
#  end
#
#
#
# ClientApplication.all.each do |ca|
#   NotificationRule.where(client_application_id: ca.id.to_s).each do |nr|
#     print("the NOTIFICATION RULE IS: #{nr.id.to_s}")
#     if nr.appointment_status.nil? or nr.appointment_status.blank?
#       puts("the status are #{Status.where(client_application_id: ca.id.to_s).inspect}")
#       status = Status.where(client_application_id: ca.id.to_s).first.id.to_s
#       nr.appointment_status = status
#       nr.save
#     end
#   end
# end




