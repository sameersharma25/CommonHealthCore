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

    arr.each do |controller|
      puts("the controller is #{controller}")
      controller.action_methods.each do |method|
        # if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
          actions << method
        # end
      end
    end

    actions
  end

end
