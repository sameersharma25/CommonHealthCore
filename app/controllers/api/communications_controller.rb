module Api
  class CommunicationsController < ActionController::Base

    def send_message
      task_id = params[:task_id]
      comm = Communication.new
      comm.sender_id = params[:sender_id]
      comm.recipient_id = params[:recipient_id]
      comm.recipient_type = params[:recipient_type]
      comm.comm_subject = params[:comm_subject]
      comm.comm_message = params[:comm_message]
      comm.comm_type = params[:comm_type]
      comm.task_id = task_id
      if comm.save
        render :json=> {status: :ok, message: "Message Sent"}
      end

    end




  end
end