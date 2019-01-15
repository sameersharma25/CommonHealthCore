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
          task.patient_document = params[:patient_document] if params[:patient_document]
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


    def get_referral
      r = Referral.find(params[:referral_id])
      referral_id = r.id.to_s
      referral_name = r.referral_name
      referral_description = r.referral_description
      urgency = r.urgency
      due_date = r.due_date
      source = r.source
      task_count = r.tasks.count
      referral_details = {referral_id: referral_id, referral_name: referral_name, referral_description: referral_description,
                          urgency: urgency, due_date: due_date,source: source, task_count: task_count }
      render :json => {status: :ok, referral_details: referral_details }
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
      task.patient_document = params[:patient_document] if params[:patient_document]
      #task.task_deadline = params[:task_deadline].to_datetime.strftime('%m/%d/%Y') if params[:task_deadline]

      task.task_description = params[:task_description] if params[:task_description]
      task.additional_fields = params[:additional_fields] if params[:additional_fields]
      if task.save
        render :json=> {status: :ok, message: "Task Created"}
      end

    end

    def get_task_status
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      status = Status.where(client_application_id: client_application.id.to_s)
      status_array = Array.new
      status.each do |s|
        status = s.status
        status_array.push(status)
      end
      render :json => {status: :ok, status_array: status_array }
    end

    def get_task

      t = Task.find(params[:task_id])
      task_id = t.id.to_s
      task_type = t.task_type
      task_status = t.task_status
      task_owner = t.task_owner
      if t.provider.blank?
        provider = "No Provider Selected"
      else
        provider = t.provider
      end
      task_deadline = t.task_deadline
      task_description = t.task_description
      additional_fields = t.additional_fields
      task_details = {task_id: task_id , task_type: task_type, task_status: task_status, task_owner: task_owner,
                      provider: provider , task_deadline: task_deadline, task_description: task_description,
                      additional_fields: additional_fields}
      render :json => {status: :ok, task_details: task_details }
    end

    def update_task
      task = Task.find(params[:task_id])
      task.task_type = params[:task_type] if params[:task_type]
      task.task_status = params[:task_status] if params[:task_status]
      task.task_owner = params[:task_owner] if params[:task_owner]
      task.provider = params[:provider] if params[:provider]
      task.task_deadline = params[:task_deadline] if params[:task_deadline]
      task.task_description = params[:task_description] if params[:task_description]
      task.patient_document = params[:patient_document] if params[:patient_document]
      if task.save
        render :json=> {status: :ok, message: "Task Updated"}
      end
    end

    def dashboard_tasks
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      referrals = Referral.where(client_application_id: client_application.id.to_s)
      today_array = []
      upcoming_array = []
      referrals.each do |r|
        r.tasks.each do |t|
          if t.task_deadline == Date.today
            task_id = t.id.to_s
            patient = t.referral.patient.first_name
            task_date = "Today"
            today_hash = {task_id: task_id, patient: patient, task_date: task_date }
            today_array.push(today_hash)
          elsif !t.task_deadline.nil?
            task_id = t.id.to_s
            patient = t.referral.patient.first_name
            task_date = !t.task_deadline.nil? ? t.task_deadline.strftime('%Y/%m/%d') : " "
            upcoming_hash = {task_id: task_id, patient: patient, task_date: task_date }
            upcoming_array.push(upcoming_hash)
          end
        end
      end

      sorted_upcoming_array = upcoming_array.sort_by { |hsh| hsh[:task_date]}

      render :json => {status: :ok, today_array: today_array, upcoming_array: sorted_upcoming_array }
    end

    def dashboard_referrals
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      referrals = Referral.where(client_application_id: client_application.id.to_s)
      new_referral_array = Array.new
      active_referral_array = Array.new
      pending_referral_array = Array.new
      task_type_collection_array = Array.new
      active_referral_time_array = Array.new
      pending_referral_time_array = Array.new
      new_referral_time_array = Array.new

      referrals.each do |r|
        r.tasks.each do |t|
          if t.task_deadline == Date.today
            ref_id = r.id.to_s
            ref_patient = r.patient.last_name + r.patient.first_name
            date = t.task_deadline.strftime('%m/%d/%Y')
            # active_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
            # active_referral_array.push(active_referral_hash)
            # break
            task_type_collection_array.push("active")
            active_referral_time_array.push(date)
          elsif !t.task_deadline.nil? && t.task_deadline != Date.today
            ref_id = r.id.to_s
            ref_patient = r.patient.last_name + r.patient.first_name
            date = t.task_deadline.strftime('%m/%d/%Y')
            # pending_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
            # pending_referral_array.push(pending_referral_hash)
            task_type_collection_array.push("pending")
            pending_referral_time_array.push(date)
          elsif t.task_deadline.nil?
            ref_id = r.id.to_s
            ref_patient = r.patient.last_name + r.patient.first_name
            date = ""
            # new_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
            # new_referral_array.push(new_referral_hash)
            task_type_collection_array.push("new")
          end
        end

        if task_type_collection_array.include? ("active")
          ref_id = r.id.to_s
          ref_patient = r.patient.last_name + r.patient.first_name
          date = active_referral_time_array.sort.last
          active_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
        elsif task_type_collection_array.include?("pending") && !task_type_collection_array.include?("active")
          ref_id = r.id.to_s
          ref_patient = r.patient.last_name + r.patient.first_name
          date = pending_referral_time_array.sort.last
          pending_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date}
          pending_referral_array.push(pending_referral_hash)
        elsif !task_type_collection_array.include?("pending") && !task_type_collection_array.include?("active") && task_type_collection_array.include?("new")
          ref_id = r.id.to_s
          ref_patient = r.patient.last_name + r.patient.first_name
          date = ""
          new_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
          new_referral_array.push(new_referral_hash)
        end

      end
      render :json => {status: :ok, new_referral_array: new_referral_array, active_referral_array: active_referral_array, pending_referral_array: pending_referral_array }

    end

    def patient_document
      user = User.find_by(email: params[:email])
      patient = Patient.find(params[:patient_id])
      client_application = user.client_application
      referrals = patient.referrals
      patient_document_array = Array.new

      referrals.each do |r|
        r.tasks.each do |t|
          if t.patient_document.present?
            logger.debug("the task is ************ #{t.inspect}")
            file_name = t.patient_document_identifier
            logger.debug("the FILE SIZE is ************ #{t.patient_document}")
            # file_size = number_to_human_size(t.patient_document.size)
            task_date = t.created_at.strftime('%m/%d/%Y')
            file_size = (t.patient_document.size)/1000.0
            task_id = t.id.to_s
            file_path = t.patient_document.url
            patient_document_hash = {file_name: file_name,file_size: file_size, task_id: task_id, task_date: task_date, file_path: file_path }
            patient_document_array.push(patient_document_hash)
          end
        end
      end
      render :json => {status: :ok,patient_document_array: patient_document_array}
    end

  end
end
