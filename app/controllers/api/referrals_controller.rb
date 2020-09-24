module Api
  class ReferralsController < ActionController::Base
    include UsersHelper
    include ClientApplicationsHelper
    before_action :authenticate_user_from_token, except: [:ext_app_ledger]
    before_action :set_user_id
    load_and_authorize_resource class: :api, except: [:ext_app_ledger]

    def create_referral
      # user = User.find_by(email: params[:email])
      # user_id = user.id.to_s
      patient = Patient.find(params[:patient_id])
      client_id = patient.client_application_id.to_s
      referral = Referral.new

      referral.source = params[:source]
      referral.referral_name = params[:referral_name]
      referral.referral_description = params[:referral_description].gsub("\\'", "'")
      referral.urgency = params[:urgency]
      referral.due_date = params[:due_date]
      referral.patient_id = patient
      referral.client_application_id = client_id
      #
      referral.client_consent = params[:client_consent]
      referral.third_party_user_id = params[:third_party_user_id]
      referral.consent_timestamp = params[:consent_timestamp]
      additional_fields = eval(params[:ref_additional_fields]) if params[:ref_additional_fields]
      referral.ref_additional_fields = additional_fields if params[:ref_additional_fields]

      referral.ref_note = params[:ref_note].gsub("\\'", "'")
      #
      referral.ref_created_by = @user_id
      referral.modifier_id = current_user.id.to_s
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
          task.task_description = t[:task_description].gsub("\\'", "'")
          task.patient_document = params[:patient_document] if params[:patient_document]
          t_additional_fields = eval(params[:task_additional_fields]) if params[:task_additional_fields]
          task.task_additional_fields = t_additional_fields if params[:task_additional_fields]
          task.task_note = params[:task_note].gsub("\\'", "'")
          task.referral_id = referral.id.to_s
          task.security_keys = helpers.security_keys_for_task(task, patient)
          if task.save
            create_ledger_master_and_status(task)
            # lm = LedgerMaster.new
            # lm.task_id = task.id.to_s
            # # lm.patient_id = patient_id
            # if lm.save
            #   led_stat = LedgerStatus.new
            #   led_stat.ledger_master_id = lm.id.to_s
            #   led_stat.ledger_status = "Accepted"
            #   led_stat.save
            # end
          end
        end

        # if task.save
          render :json=> {status: :ok, message: "Referral and Task Created"}
        # else
        #   render :json=> {status: :ok, message: "Referral and Task not Created"}
        # end
      end
    end


    def create_ledger_master_and_status(task)
      lm = LedgerMaster.new
      lm.task_id = task.id.to_s
      # lm.patient_id = patient_id
      if lm.save
        led_stat = LedgerStatus.new
        led_stat.ledger_master_id = lm.id.to_s
        led_stat.ledger_status = "Accepted"
        led_stat.save
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
        client_consent = r.client_consent
        ref_additional_fields = r.ref_additional_fields
        ref_note = r.ref_note

        status = r.status
        follow_up_date = r.follow_up_date
        agreement_notification_flag = r.agreement_notification_flag


        referral_details = {referral_id: referral_id, referral_name: referral_name, referral_description: referral_description,
                            urgency: urgency, due_date: due_date,source: source, task_count: task_count,  status: status, 
                            follow_up_date: follow_up_date, agreement_notification_flag: agreement_notification_flag,
                            ref_additional_fields: ref_additional_fields, ref_note: ref_note}
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
      status = r.status
      client_consent = r.client_consent
      follow_up_date = r.follow_up_date
      agreement_notification_flag = r.agreement_notification_flag
      patient_id = r.patient.id.to_s
      ref_additional_fields = r.ref_additional_fields
      ref_note = r.ref_note

      referral_details = {referral_id: referral_id, referral_name: referral_name, referral_description: referral_description,
                          urgency: urgency, due_date: due_date,source: source, task_count: task_count,  status: status, 
                          follow_up_date: follow_up_date, agreement_notification_flag: agreement_notification_flag,
                          patient_id: patient_id, ref_additional_fields: ref_additional_fields, ref_note: ref_note}
      render :json => {status: :ok, referral_details: referral_details }
    end

    def update_referral
      referral = Referral.find(params[:referral_id])

      referral.source = params[:source] if params[:source]
      referral.referral_name = params[:referral_name] if params[:referral_name]
      referral.referral_description = params[:referral_description].gsub("\\'", "'") if params[:referral_description]
      referral.urgency = params[:urgency] if params[:urgency]
      referral.due_date = params[:due_date] if params[:due_date]

      referral.status = params[:status] if params[:status]
      referral.follow_up_date = params[:follow_up_date] if params[:follow_up_date]
      referral.agreement_notification_flag = params[:agreement_notification_flag] if params[:agreement_notification_flag]
      
      referral.client_consent = params[:client_consent]
      referral.third_party_user_id = params[:third_party_user_id]
      referral.consent_timestamp = params[:consent_timestamp]
      additional_fields = eval(params[:ref_additional_fields]) if params[:ref_additional_fields]
      referral.ref_additional_fields = additional_fields if params[:ref_additional_fields]

      referral.ref_note = params[:ref_note].gsub("\\'", "'")
      referral.modifier_id = current_user.id.to_s
      
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
        transferable = t.transferable
        transfer_status = t.transfer_status
        task_additional_fields = t.task_additional_fields
        task_note = t.task_note.gsub("\\'", "'")

        task_details = {task_id: task_id , task_type: task_type, task_status: task_status, task_owner: task_owner,
                        provider: provider , task_deadline: task_deadline, task_description: task_description,
                        additional_fields: additional_fields, transferable: transferable, transfer_status: transfer_status,
                        task_additional_fields: task_additional_fields, task_note: task_note}
        task_list.push(task_details)
      end

      referral = Referral.find(params[:referral_id])
      details_array = []
      needs = referral.needs
      needs.each do |need|
        need_id = need.id.to_s
        need_title =  need.need_title,
            need_description = need.need_description,
            need_note = need.need_notes,
            need_urgency = need.need_urgency,
            need_status = need.need_status

        logger.debug("******************the need Title is : #{need.inspect}")
        need_hash = {need_id: need_id, need_title: need_title.first, need_description: need_description,
                     need_note: need_note, need_urgency: need_urgency, need_status: need_status,
                     obstacles_array: []}
        logger.debug("******************the need HASH is : #{need_hash}")

        need_obstacles = need.obstacles
        need_obstacles.each do |obstacle|
          obstacle_id = obstacle.id.to_s
          obstacle_title = obstacle.obstacle_title,
              obstacle_description = obstacle.obstacle_description,
              obstacle_notes = obstacle.obstacle_notes,
              obstacle_urgency = obstacle.obstacle_urgency,
              obstacle_status = obstacle.obstacle_status

          obstacle_hash = { obstacle_id: obstacle_id,obstacle_title: obstacle_title.first,
                            obstacle_description: obstacle_description,
                            obstacle_notes: obstacle_notes, obstacle_urgency: obstacle_urgency,
                            obstacle_status: obstacle_status, solutions_array: []}


          obstacle_solutions = obstacle.solutions
          obstacle_solutions.each do |solution|
            solution_id = solution.id.to_s
            solution_title = solution.solution_title
            solution_description = solution.solution_description
            solution_provider = solution.solution_provider

            solution_hash = {solution_id: solution_id, solution_title: solution_title,
                             solution_description: solution_description, solution_provider: solution_provider }
            obstacle_hash[:solutions_array].push(solution_hash) if solution_hash
          end
          need_hash[:obstacles_array].push(obstacle_hash)
        end

        details_array.push(need_hash)
      end

      render :json => {status: :ok, task_list: task_list, int_list: details_array }

    end

    def referral_assessments
      referral = Referral.find(params[:referral_id])
      needs = referral.needs
      needs_array = []

      needs.each do |n|
        need_id = n.id.to_s
        need_title = n.need_title
        need_description = n.need_description
        need_urgency = n.need_urgency
        need_status = n.need_status
        need_details = {need_id: need_id, need_title: need_title , need_description: need_description, need_urgency: need_urgency,
                        need_status: need_status }
        needs_array.push(need_details)
      end
      render :json => {status: :ok, needs_array: needs_array }
    end

    def create_task
      #task = Task.new
      if !params[:solution_id].blank?
        referral = Solution.find(params[:solution_id]).obstacle.need.referral
        sol_task = Task.where(solution_id: params[:solution_id])
        if sol_task.blank?
          task = Task.new
        else
          task = sol_task.first
        end
        task.solution_id = params[:solution_id]
      else
        task = Task.new
        referral = Referral.find(params[:referral_id])
      end

      patient_id = referral.patient.id.to_s

      task.referral_id = referral
      task.task_type = params[:task_type] if params[:task_type]
      task.task_status = params[:task_status] if params[:task_status]
      task.task_owner = params[:task_owner] if params[:task_owner]
      task.provider = params[:provider] if params[:provider]
      task.task_deadline = params[:task_deadline] if params[:task_deadline]
      task.patient_document = params[:patient_document] if params[:patient_document]
      
      task.security_keys = helpers.security_keys_for_task(task, referral.patient)
      #task.task_deadline = params[:task_deadline].to_datetime.strftime('%m/%d/%Y') if params[:task_deadline]

      task.task_description = params[:task_description].gsub("\\'", "'") if params[:task_description]
      # task.additional_fields = params[:additional_fields] if params[:additional_fields]
      t_additional_fields = eval(params[:task_additional_fields]) if params[:task_additional_fields]
      task.task_additional_fields = t_additional_fields if params[:task_additional_fields]
      task.task_note = params[:task_note].gsub("\\'", "'")
      if task.save
        create_ledger_master_and_status(task)
        # lm = LedgerMaster.new
        # lm.task_id = task.id.to_s
        # # lm.patient_id = patient_id
        # if lm.save
        #   led_stat = LedgerStatus.new
        #   led_stat.ledger_master_id = lm.id.to_s
        #   led_stat.ledger_status = "Accepted"
        #   led_stat.save
        # end
        render :json=> {status: :ok, message: "Task Created", task_id: task.id.to_s}
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
      # additional_fields = t.additional_fields
      task_additional_fields = t.task_additional_fields
      task_note = t.task_note
      task_details = {task_id: task_id , task_type: task_type, task_status: task_status, task_owner: task_owner,
                      provider: provider , task_deadline: task_deadline, task_description: task_description,
                      task_additional_fields: task_additional_fields, task_note: task_note}
      render :json => {status: :ok, task_details: task_details }
    end

    def update_task
      task = Task.find(params[:task_id])
      patient = Task.find(params[:task_id]).referral.patient
      task.task_type = params[:task_type] if params[:task_type]
      task.task_status = params[:task_status] if params[:task_status]
      task.task_owner = params[:task_owner] if params[:task_owner]
      task.provider = params[:provider] if params[:provider]
      task.task_deadline = params[:task_deadline] if params[:task_deadline]
      task.task_description = params[:task_description].gsub("\\'", "'") if params[:task_description]
      task.patient_document = params[:patient_document] if params[:patient_document]
      t_additional_fields = eval(params[:task_additional_fields]) if params[:task_additional_fields]
      task.task_additional_fields = t_additional_fields if params[:task_additional_fields]
      task.task_note = params[:task_note].gsub("\\'", "'")
      #Create Ledger Record
      #new_ledger = LedgerRecord.new


      task.security_keys = []
      task.security_keys = helpers.security_keys_for_task(task, patient)
      changes = task.changes
      if task.save
        ledger_master = LedgerMaster.where(task_id: task.id).first
        # client_id = task.referral.client_application_id
        ledger_status= ledger_master.ledger_statuses.first
        new_record = LedgerRecord.new
        new_record.changed_fields = changes
        new_record.ledger_status_id = ledger_status.id.to_s
        new_record.save

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
      # task_type_collection_array = Array.new
      active_referral_time_array = Array.new
      pending_referral_time_array = Array.new
      new_referral_time_array = Array.new
      #
      # referrals.each do |r|
      #   task_type_collection_array = Array.new
      #   r.tasks.each do |t|
      #     if t.task_deadline == Date.today
      #       ref_id = r.id.to_s
      #       ref_patient = r.patient.last_name + r.patient.first_name
      #       date = t.task_deadline.strftime('%m/%d/%Y')
      #       # active_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
      #       # active_referral_array.push(active_referral_hash)
      #       # break
      #       task_type_collection_array.push("active")
      #       active_referral_time_array.push(date)
      #     elsif !t.task_deadline.nil? && t.task_deadline != Date.today
      #       ref_id = r.id.to_s
      #       ref_patient = r.patient.last_name + r.patient.first_name
      #       date = t.task_deadline.strftime('%m/%d/%Y')
      #       # pending_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
      #       # pending_referral_array.push(pending_referral_hash)
      #       task_type_collection_array.push("pending")
      #       pending_referral_time_array.push(date)
      #     elsif t.task_deadline.nil?
      #       ref_id = r.id.to_s
      #       ref_patient = r.patient.last_name + r.patient.first_name
      #       date = ""
      #       # new_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date }
      #       # new_referral_array.push(new_referral_hash)
      #       task_type_collection_array.push("new")
      #     end
      #   end
      #
      #   if task_type_collection_array.include? ("active")
      #     ref_id = r.id.to_s
      #     ref_patient = r.patient.last_name + r.patient.first_name
      #     date = active_referral_time_array.sort.last
      #     active_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date, ref_source: r.source, ref_description: r.referral_description, ref_urgency: r.urgency }
      #     active_referral_array.push(active_referral_hash)
      #   elsif task_type_collection_array.include?("pending") && !task_type_collection_array.include?("active")
      #     ref_id = r.id.to_s
      #     ref_patient = r.patient.last_name + r.patient.first_name
      #     date = pending_referral_time_array.sort.last
      #     pending_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date, ref_source: r.source, ref_description: r.referral_description, ref_urgency: r.urgency}
      #     pending_referral_array.push(pending_referral_hash)
      #   elsif !task_type_collection_array.include?("pending") && !task_type_collection_array.include?("active") && task_type_collection_array.include?("new")
      #     ref_id = r.id.to_s
      #     ref_patient = r.patient.last_name + r.patient.first_name
      #     date = ""
      #     new_referral_hash = {ref_id: ref_id, ref_patient: ref_patient,date: date, ref_source: r.source, ref_description: r.referral_description, ref_urgency: r.urgency}
      #     new_referral_array.push(new_referral_hash)
      #   end
      #
      # end
      referrals.each do |r|
        task_type_collection_array = Array.new
        r.tasks.each do |t|
          date = t.task_deadline.strftime('%m/%d/%Y') if t.task_deadline
        end
        date = r.tasks.last.task_deadline.strftime('%m/%d/%Y') if (r.tasks.last && !r.tasks.last.task_deadline.nil?)
        ref_id = r.id.to_s
        ref_patient = r.patient.last_name + r.patient.first_name
        p_last_name = r.patient.last_name
        p_first_name = r.patient.first_name
        client_consent = r.patient.client_consent
        follow_up_date = r.follow_up_date
        status = r.status
        patient_id = r.patient.id.to_s
        submission_date = r.tasks.last.nil? ? "" :  r.tasks.last.created_at.strftime('%m/%d/%Y')

        new_referral_hash = {patient_id: patient_id,ref_id: ref_id, ref_patient: ref_patient,date: date, ref_source: r.source, ref_description: r.referral_description,
                             ref_urgency: r.urgency, p_last_name: p_last_name, p_first_name: p_first_name, client_consent: client_consent,
                             follow_up_date: follow_up_date, status: status, submission_date: submission_date }
        new_referral_array.push(new_referral_hash)
      end
      # render :json => {status: :ok, new_referral_array: new_referral_array, active_referral_array: active_referral_array, pending_referral_array: pending_referral_array }
      render :json => {status: :ok, new_referral_array: new_referral_array.sort_by{|h| h[:submission_date]}.reverse }
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

    def create_ledger_record

      lr = LedgerRecord.new
      lr.ledger_master_id = params[:ledger_master_id]
      lr.referred_application_id = params[:referred_application_id]
      lr.referred_change_type = params[:referred_change_type]
      lr.referred_application_object_id = params[:referred_application_object_id]
      lr.referred_application_object_type = params[:referred_application_object_type]
      lr.save

    end

    def ext_app_ledger
      lm = LedgerMaster.new
      lm.task_id = params[:task_values][:task_id]
      # lm.patient_id = patient_id
      if lm.save
        ledger_master_id = lm.id.to_s

        led_stat = LedgerStatus.new
        led_stat.referred_application_id = params[:task_values][:referred_application_id]
        led_stat.ledger_master_id = ledger_master_id
        led_stat.ledger_status = "Pending"
        if led_stat.save
          logger.debug("NOTIFICATION FOR REFERAL WILL BE SENT**********")
        end
      end
    end

    def invite_org
      all_applications = ClientApplication.all.pluck(:name)

      if all_applications.include?(params[:name])
        req_status = "bad_request"
        req_message = "An account with the same name already exists."
      else
        ca = ClientApplication.new
        ca.name = params[:name]
        ca.application_url = params[:application_url]
        ca.external_application = params[:external_application]
        ca.master_application_status = false
        if ca.save
          admin_role = Role.create(client_application_id: ca.id.to_s ,role_name: "Admin", role_abilities: [{"action"=>[:manage], "subject"=>[:all]}])
          if params[:user_email]
            logger.debug("*********invit_org Before the send invire to user ")
            user_invite = helpers.send_invite_to_user(params[:user_email],ca,
                                              params[:name], admin_role.id.to_s )
            if user_invite == true
               helpers.send_referral_common(params[:task_id],ca.id.to_s, @user_id)
            end
            # render :json => {status: :ok ,message: "Organization Invited."}
            req_status = "ok"
            req_message = "Thank you your invitation to the CHC network was successfully submitted."
          end
        else
          # render :json => {status: :bad_request ,message: "Organization not invited."}
          req_status = "bad_request"
          req_message = "Organization not invited."
        end
      end


      render :json => {status: req_status ,message: req_message }
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_id
      user = User.find_by(email: params[:email])
      @user_id = user.id.to_s
    end

  end
end
