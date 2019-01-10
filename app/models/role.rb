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
                         "patient_appointments","password"]
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
