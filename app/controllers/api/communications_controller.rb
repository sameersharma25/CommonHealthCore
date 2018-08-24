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

    end

    def get_messages
      comm_id = params[:comm_id]
      comm = Communication.find(comm_id)
      logger.debug("the comm is : #{comm.inspect}")
    end

  end
end