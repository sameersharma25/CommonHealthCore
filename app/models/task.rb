require 'net/http'
require 'uri'
require 'json'

class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :task_type, type: String
  field :task_status, type: String
  field :task_owner, type: String
  field :provider , type: String
  field :task_deadline, type: DateTime
  field :task_description, type: String
  field :additional_fields, type: Hash
  field :task_referred_from, type: String
  field :security_keys, type: Array, default: []
  field :medical_case, type: Boolean, default: false
  field :solution_id, type: String
  field :transferable, type: Boolean, default: true
  field :transfer_status, type: String
  mount_uploader :patient_document , PatientFileUploader

  belongs_to :referral
  has_many :communications
  has_many :notifications

  track_history   :on => [:all],       # track title and body fields only, default is :all
                  :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier, set to nil to not create modifier_field
                  :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
                  :modifier_field_optional => true, # marks the modifier relationship as optional (requires Mongoid 6 or higher)
                  :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  :track_create  => true,       # track document creation, default is true
                  :track_update  => true,       # track document updates, default is true
                  :track_destroy => true        # track document destruction, default is true


  before_save :add_modifier

  def self.tasks_for_notifications
    client_applications = ClientApplication.all

    client_applications.each do |c|
      client_application_id = c.id.to_s
      application_notification_rules_statuses = NotificationRule.where(client_application_id: client_application_id).collect{|nr| Status.find(nr.appointment_status).status}.uniq

      tasks = Task.where(:task_status.in => application_notification_rules_statuses)

      tasks.each do |task|
        if !task.task_deadline.nil?
          task_status = task.task_status
          task_id = task.id.to_s
          # created_at = task.created_at.strftime('%Y-%m-%d %H:%M:%S')

          puts("the task dead line is : #{task.task_deadline}")
          due_date = task.task_deadline.strftime('%Y-%m-%d %H:%M:%S')

          input = {"input": "{\"task\": \"#{task_id}\", \"status\": \"#{task_status}\",\"due_date\": \"#{due_date}\" }", "stateMachineArn": "arn:aws:states:us-west-2:394013058182:stateMachine:Helloworld"}
          uri = URI("https://f6v0zpby6h.execute-api.us-west-2.amazonaws.com/prod")


          header = {'Content-Type' => 'text/json'}
          # user = {user: {
          #     name: 'Bob',
          #     email: 'bob@example.com'
          # }
          # }

          # Create the HTTP objects
          http = Net::HTTP.new(uri.host, uri.port)
          puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path, header)
          request.body = input.to_json

          # Send the request
          response = http.request(request)
          puts "response #{response.body}"
          puts JSON.parse(response.body)
        end
      end
    end
  end

  def add_modifier
    # Rails.logger.debug("in the USER in patient model -------- #{User.current.inspect}")
    self.modifier_id = User.current.id.to_s
  end
end
