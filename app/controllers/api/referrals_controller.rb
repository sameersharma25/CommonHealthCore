module Api
  class ReferralsController < ActionController::Base
    # include UsersHelper
    # before_action :authenticate_user_from_token, except: [:give_appointment_details_for_notification,  :set_password]

    def create_referral
      patient = Patient.find(params[:patient_id])
      referral = Referral.new

      referral.source = params[:source]
      referral.referral_name = params[:referral_name]
      referral.referral_description = params[:referral_description]
      referral.urgency = params[:urgency]
      referral.due_date = params[:due_date]
      referral.patient_id = patient
      referral.save
      if params[:task].blank?
        if referral.save
          render :json=> {status: :ok, message: "Referral Created"}
        else
          render :json=> {status: :ok, message: "Referral not Created"}
        end
      elsif !params[:task].blank?
        logger.debug("Create task********************")
        task = Task.new
        task.task_type = params[:task][:task_type]
        task.task_status = params[:task][:task_status]
        task.task_owner = params[:task][:task_owner]
        task.provider = params[:task][:provider]
        task.task_deadline = params[:task][:task_deadline]
        task.task_description = params[:task][:task_description]
        task.referral_id = referral.id.to_s
        if task.save
          render :json=> {status: :ok, message: "Referral and Task Created"}
        else
          render :json=> {status: :ok, message: "Referral and Task not Created"}
        end
      end
    end


    def referral_list
      patient = Patient.find(params[:patient_id])
      referral_list = Array.new

      patient.referrals.each do |r|
        referral_name = r.referral_name
        referral_description = r.referral_description
        urgency = r.urgency
        due_date = r.due_date
        referral_details = {referral_name: referral_name, referral_description: referral_description,
                            urgency: urgency, due_date: due_date }
        referral_list.push(referral_details)
      end

      render :json => {status: :ok, referral_list: referral_list }
    end

    def task_list
      # patient = Patient.find(params[:patient_id])
      referral = Referral.find(params[:referral_id])
      task_list = Array.new

      referral.tasks.each do |t|
        task_id = t.id.to_s
        task_type = t.task_type
        task_status = t.task_status
        task_owner = t.task_owner
        provider = t.provider
        task_deadline = t.task_deadline
        task_description = t.task_description
        task_details = {task_id: task_id , task_type: task_type, task_status: task_status, task_owner: task_owner,
                        provider: provider , task_deadline: task_deadline, task_description: task_description,
                        }
        task_list.push(task_details)
      end

      render :json => {status: :ok, task_list: task_list }

    end

    def create_task
      referral = Referral.find(params[:referral_id])
      task = Task.new
      task.referral_id = referral
      task.task_type = params[:task_type] if params[:task_type]
      task.task_status = params[:task_status] if params[:task_status]
      task.task_owner = params[:task_owner] if params[:task_owner]
      task.provider = params[:provider] if params[:provider]
      task.task_deadline = params[:task_deadline] if params[:task_deadline]
      task.task_description = params[:task_description] if params[:task_description]
      if task.save
        render :json=> {status: :ok, message: "Task Created"}
      end


    end

  end
end
