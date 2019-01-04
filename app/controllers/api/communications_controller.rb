require 'net/http'
require 'uri'
require 'json'

module Api
  class CommunicationsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:get_messages]
    load_and_authorize_resource class: :api

    def send_message
      # if params[:comm_id]
      #   comm = Communication.find(params[:comm_id])
      #   task = Task.find(comm.task_id.to_s)
      #
      # else
      #   task_id = params[:task_id]
      #   patient = Task.find(task_id).referral.patient
      #   if patient.mode_of_contact
      #     comm_type = patient.mode_of_contact
      #     if comm_type == "text"
      #       send_to = patient.patient_phone
      #     elsif comm_type == "email"
      #       send_to = patient.patient_email
      #     end
      #   else
      #     comm_type = "text"
      #     send_to = patient.patient_phone
      #   end
      # end

      communication = Communication.find(params[:comm_id]) if params[:comm_id]
      if params[:comm_id]
        recipient_id = communication.sender_id
        recipient_type = communication.recipient_type

      end
      task_id = params[:comm_id] ? communication.task_id : params[:task_id]
      patient = Task.find(task_id).referral.patient
      logger.debug("the patient details are : #{patient.inspect}")
      if patient.mode_of_contact
        comm_type = patient.mode_of_contact
        if comm_type == "text"
          send_to = patient.patient_phone
        elsif comm_type == "email"
          send_to = patient.patient_email
        end
      else
        comm_type = "text"
        send_to = patient.patient_phone
      end
      logger.debug("the communication type is: #{comm_type}")
      comm = Communication.new
      comm.sender_id = params[:sender_id]
      comm.recipient_id = params[:comm_id] ? recipient_id : params[:recipient_id]
      comm.recipient_type = params[:comm_id] ? recipient_type : params[:recipient_type]
      comm.comm_subject = params[:comm_subject]
      comm.comm_message = params[:comm_message]
      comm.comm_type = comm_type
      comm.task_id = task_id
      comm.from_cc = true
      if comm.save
        #https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message
        # uri = URI("https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message?commType=#{comm.comm_type}&commMessage=#{comm.comm_message}&commSubject=#{comm.comm_message}&sendTo=#{send_to}&commId=#{comm.id.to_s}")
        uri = URI("https://f9nmqkovog.execute-api.us-west-2.amazonaws.com/prod?commType=#{comm.comm_type}&commMessage=#{comm.comm_message}&commSubject=#{comm.comm_message}&sendTo=#{send_to}&commId=#{comm.id.to_s}")
        # uri = URI("https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message?commType=text&commMessage=sending message from rails with out line break&sendTo=+13126135585&commId=#{comm.id.to_s}")

        res = Net::HTTP.get(uri)
        logger.debug("the response of the get request is : #{res.inspect}")

        render :json=> {status: :ok, message: "Message Sent"}
      end

    end


    def message_list
      comm_array = Array.new
      if params[:task_id]
        t = Task.find(params[:task_id])
        t.communications.each do |c|
          communication= create_message_list_hash(c)
          comm_array.push(communication)
        end
      elsif params[:patient_id]
        patient_id = params[:patient_id]
        patient = Patient.find(patient_id)
        referrals = patient.referrals
        referrals.each do |r|
          tasks = r.tasks
          tasks.each do |t|
            t.communications.each do |c|
              communication= create_message_list_hash(c)
              comm_array.push(communication)
            end
          end
        end
      end
      render :json=> {status: :ok, :comm_data=> comm_array }
    end

    def create_message_list_hash(c)
      subject = c.comm_subject
      message = c.comm_message
      from_cc = c.from_cc
      id = c.id.to_s
      created_at = c.created_at.strftime("%m/%d/%Y %I:%M%p")
      if !c.sender_id.nil?
        if c.from_cc == true
          sender = User.find(c.sender_id)
          sender_name = sender.name
        elsif c.from_cc == false
          sender = Patient.find(c.sender_id)
          sender_name = sender.first_name
        end
      else
        sender_name = ""
      end
      communication = {subject: subject, message: message, from_cc: from_cc, id: id, created_at: created_at, sender_name: sender_name}
    end

    def get_messages
      comm_id = params[:comm_id]
      message = params[:message]
      comm = Communication.find(comm_id)
      task_id = comm.task.id.to_s
      sender = comm.recipient_id

      new_comm = Communication.new
      new_comm.comm_message = message
      new_comm.sender_id = sender
      new_comm.task_id = task_id
      new_comm.comm_type = comm.comm_type
      new_comm.comm_subject = comm.comm_subject
      new_comm.from_cc = false
      new_comm.save

      logger.debug("the comm is : #{comm.inspect}")
      render :json=> {status: :ok, :message=> "Response Sent" }
    end

    def task_message_list
      task_msg_array = Array.new
      patient_id = params[:patient_id]
      patient = Patient.find(patient_id)
      referrals = patient.referrals
      referrals.each do |r|
        tasks = r.tasks
        tasks.each do |t|
          task_id = t.id.to_s
          provider = t.provider
          task_type = t.task_type
          msg_count = t.communications.count
          task_msg = {task_id: task_id,task_type: task_type,provider: provider, msg_count: msg_count}
          task_msg_array.push(task_msg)
        end
      end
      render :json=> {status: :ok, :task_msg_data=> task_msg_array }
    end

    def dashboard_messages
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      messagess = Communication.where(client_application_id: client_application.id.to_s).order_by(created_at: :desc).first(5)
      message_array = []
      referrals = Referral.where(client_application_id: client_application.id.to_s)

      referrals.each do |r|
        r.tasks.each do |t|
          t.communications.each do |c|
            msg_id = m.id.to_s
            message = m.comm_message
            created_at = m.created_at
            message_hash = {msg_id: msg_id, message: message, created_at: created_at}
            message_array.push(message_hash )
          end
        end
      end
      sorted_list = message_array.sort_by { |hsh| hsh[:created_at] }

      render :json => {status: :ok, message_array: sorted_list }
    end

  end
end