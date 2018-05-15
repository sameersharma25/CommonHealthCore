require 'net/http'
require 'uri'
require 'json'

class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :date_of_appointment, type: String
  field :reason_for_visit, type: Array, default: []
  field :status, type: String
  field :service_provider_id, type: Integer
  field :cc_id, type: String

  field :last_notified, type: String


  belongs_to :client_application
  belongs_to :patient
  belongs_to :user
  has_many :notifications




  def self.appointments_for_notification
    a = Appointment.last
    created_at = a.created_at.strftime('%Y-%m-%d %H:%M:%S')
    appointment = a.id.to_s
    status = a.status
    puts "created at is: #{created_at.to_s}"
    input = {"input": "{\"appointment\": \"#{appointment}\", \"status\": \"#{status}\", \"created_at\": \"#{created_at}\"}", "stateMachineArn": "arn:aws:states:us-east-1:193584522294:stateMachine:Helloworld"}
    #system"curl -X POST -d \"#{input}\" https://770xc1lwwg.execute-api.us-east-1.amazonaws.com/alpha/execution"

   # system "curl -X POST -d \'{\"input\": \"{\"appointment\": \"5ad81aa4e95465658a075507\", \"status\": \"New\", \"created_at\": \"2018-04-25 13:23:47\"}\",\"stateMachineArn\": \"arn:aws:states:us-east-1:193584522294:stateMachine:Helloworld\"}\' https://770xc1lwwg.execute-api.us-east-1.amazonaws.com/alpha/execution"

    uri = URI("https://770xc1lwwg.execute-api.us-east-1.amazonaws.com/alpha/execution")

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
