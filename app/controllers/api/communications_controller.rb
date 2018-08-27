require 'net/http'
require 'uri'
require 'json'

module Api
  class CommunicationsController < ActionController::Base

    def send_message
      task_id = params[:task_id]
      patient = Task.find(task_id).referral.patient
      if patient.mode_of_contact
        comm_type = patient.mode_of_contact
        if comm_type == "text"
          send_to = patient.patient_phone
        elsif comm_type == "text"
          send_to = patient.patient_email
        end
      else
        comm_type = "text"
        send_to = patient.patient_phone
      end
      comm = Communication.new
      comm.sender_id = params[:sender_id]
      comm.recipient_id = params[:recipient_id]
      comm.recipient_type = params[:recipient_type]
      comm.comm_subject = params[:comm_subject]
      comm.comm_message = params[:comm_message]
      comm.comm_type = comm_type
      comm.task_id = task_id
      if comm.save
        #https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message
        uri = URI("https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message?commType=#{comm.comm_type}&commMessage=#{comm.comm_message}&commSubject=#{comm.comm_message}&sendTo=#{send_to}&commId=#{comm.id.to_s}")
        # uri = URI("https://kl94y9g3yc.execute-api.us-east-1.amazonaws.com/send_message?commType=text&commMessage=sending message from rails with out line break&sendTo=+13126135585&commId=#{comm.id.to_s}")

        res = Net::HTTP.get(uri)
        logger.debug("the response of the get request is : #{res.inspect}")

        render :json=> {status: :ok, message: "Message Sent"}
      end

    end


    def message_list
      patient_id = params[:patient_id]
      patient = Patient.find(patient_id)
      referrals = patient.referrals
      comm_array = Array.new

      referrals.each do |r|
        tasks = r.tasks
        tasks.each do |t|
          t.communications.each do |c|
            subject = c.comm_subject
            message = c.comm_message
            communication = {subject: subject, message: message }
            comm_array.push(communication)
          end
        end
      end

      render :json=> {status: :ok, :comm_data=> comm_array }

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
      new_comm.save
      
      logger.debug("the comm is : #{comm.inspect}")
      render :json=> {status: :ok, :message=> "Response Sent" }
    end

  end
end