module Api
  class ReferralsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: []
    load_and_authorize_resource class: :api
    def create_referral
      patient = Patient.find(params[:patient_id])
      client_id = patient.client_application_id.to_s
      referral = Referral.new

      referral.source = params[:source]
      referral.referral_name = params[:referral_name]
      referral.referral_description = params[:referral_description]
      referral.urgency = params[:urgency]
      referral.due_date = params[:due_date]
      referral.patient_id = patient
      referral.client_application_id = client_id
      referral.save
      if params[:task].blank?
        if referral.save
          render :json=> {status: :ok, message: "Referral Created"}
        else
          render :json=> {status: :ok, message: "Referral not Created"}
        end
      elsif !params[:task].blank?
        logger.debug("Create task********************")
        params[:task].each do |t|
          logger.debug("****************the TASK is : #{t}")
          task = Task.new
          task.task_type = t[:task_type]
          task.task_status = t[:task_status]
          task.task_owner = t[:task_owner]
          task.provider = t[:provider]
          task.task_deadline = t[:task_deadline]
          task.task_description = t[:task_description]
          task.referral_id = referral.id.to_s
          task.save
        end

        # if task.save
          render :json=> {status: :ok, message: "Referral and Task Created"}
        # else
        #   render :json=> {status: :ok, message: "Referral and Task not Created"}
        # end
      end
    end


    def referral_list
      patient = Patient.find(params[:patient_id])
      referral_list = Array.new

      patient.referrals.each do |r|
        referral_id = r.id.to_s
        referral_name = r.referral_name
        referral_description = r.referral_description
        urgency = r.urgency
        due_date = r.due_date
        source = r.source
        task_count = r.tasks.count
        referral_details = {referral_id: referral_id, referral_name: referral_name, referral_description: referral_description,
                            urgency: urgency, due_date: due_date,source: source, task_count: task_count }
        referral_list.push(referral_details)
      end

      render :json => {status: :ok, referral_list: referral_list }
    end

    def update_referral
      referral = Referral.find(params[:referral_id])

      referral.source = params[:source] if params[:source]
      referral.referral_name = params[:referral_name] if params[:referral_name]
      referral.referral_description = params[:referral_description] if params[:referral_description]
      referral.urgency = params[:urgency] if params[:urgency]
      referral.due_date = params[:due_date] if params[:due_date]
      if referral.save
        render :json=> {status: :ok, message: "Referral Updated"}
      end
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
        additional_fields = t.additional_fields
        task_details = {task_id: task_id , task_type: task_type, task_status: task_status, task_owner: task_owner,
                        provider: provider , task_deadline: task_deadline, task_description: task_description,
                        additional_fields: additional_fields}
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
      #task.task_deadline = params[:task_deadline].to_datetime.strftime('%m/%d/%Y') if params[:task_deadline]

      task.task_description = params[:task_description] if params[:task_description]
      task.additional_fields = params[:additional_fields] if params[:additional_fields]
      if task.save
        render :json=> {status: :ok, message: "Task Created"}
      end


    end

    def update_task
      task = Task.find(params[:task_id])
      task.task_type = params[:task_type] if params[:task_type]
      task.task_status = params[:task_status] if params[:task_status]
      task.task_owner = params[:task_owner] if params[:task_owner]
      task.provider = params[:provider] if params[:provider]
      task.task_deadline = params[:task_deadline] if params[:task_deadline]
      task.task_description = params[:task_description] if params[:task_description]
      if task.save
        render :json=> {status: :ok, message: "Task Updated"}
      end
    end

  end
end


#[{"name": "time", "place": "resource"}, {"name": "stack", "place": "chron"}]