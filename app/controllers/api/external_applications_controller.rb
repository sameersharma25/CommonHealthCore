require 'net/http'
require 'uri'
require 'json'

module Api
  class ExternalApplicationsController < ActionController::Base

    def render_script
      render html: '<div>html goes here</div>'.html_safe
    end


    def reject_request
      task_id = params[:task_id]
      task = Task.find(task_id)
      ledger_master = LedgerMaster.where(task_id: task_id).first
      existing_status= ledger_master.ledger_statuses.where(referred_application_id: params[:external_application_id] ).first

      existing_status.ledger_status = "Rejected"
      existing_status.request_reject_reason = params[:request_reject_reason]
      existing_status.save

      render :json=> {status: :ok, message: "Request Rejected " }
    end

    def send_patient #Which person should I email if it fails???
      task_id = params[:task_id]
      task = Task.find(task_id)
      patient = task.referral.patient

      ledger_master = LedgerMaster.where(task_id: task_id).first
      existing_status= ledger_master.ledger_statuses.where(referred_application_id: params[:external_application_id] ).first

      external_application_id = params[:external_application_id]
      external_application = ClientApplication.find(external_application_id)
      client_application = ClientApplication.find(patient.client_application_id)


      if external_application.external_application == true
        external_api = ExternalApiSetup.where(client_application_id: external_application_id, api_for: "send_patient").first

        patient_hash = Hash.new
        logger.debug("the MAPPED PARAMETERS ARE: #{external_api.mapped_parameters.entries}")
        external_api.mapped_parameters.each do|mp|
          external_parameter = mp.external_parameter
          chc_parameter = mp.chc_parameter # first_name
          chc_value = patient[chc_parameter]
          patient_hash[external_parameter] = chc_value
          logger.debug("the parameter value is : EXTERNAL:  #{external_parameter}, CHC : #{chc_parameter} -----#{chc_value}")
        end

        input = {"patient_hash": patient_hash}
        uri = URI("http://localhost:3001/api/add_external_patients")


        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
        # http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, header)
        request.body = input.to_json

        # Send the request
        response = http.request(request)
        puts "response #{response.body}"
        puts JSON.parse(response.body)
        result = JSON.parse(response.body)
        logger.debug("the patient id is : #{result}")
          if !result["p_id"].nil?
            logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                ###
                if patient.security_keys.length > 0 || task.security_keys.length > 0
                    #logger.debug("patient details #{patient.inspect}******* task details #{task.inspect}")
                        if client_application.agreement_type == external_application.agreement_type
                            #logger.debug("client_application #{client_application.inspect}")
                              #logger.debug("external_application #{external_application.inspect}")
                             if !client_application.client_agreement.url.nil? && !external_application.client_agreement.url.nil?
                               send_task(result["p_id"], task,external_application_id,existing_status, patient)
                             else 
                              #Do Not Send: Email: Sorry, the agreement types do not match
                              SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                             end 
                        else
                            #Do Not Sent: Email: Sorry, you still need to sign your Agreement or more.
                            SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                        end 
                else 
                    send_task(result["p_id"], task,external_application_id,existing_status,patient)
                end 
                ###
          else
            logger.debug('the PATIENT ID WAS nil***************')
          end
      else
        patient_check = Patient.where(client_application_id: external_application_id, first_name: patient.first_name, last_name: patient.last_name).first
        logger.debug("Creating patient for internal application******************* #{patient_check}")
        if patient_check.nil?
          logger.debug("Creating new Patient*********************")
          new_patient = Patient.new
          new_patient.client_application_id = external_application_id
          new_patient.first_name = patient.first_name
          new_patient.last_name = patient.last_name
          new_patient.date_of_birth = patient.date_of_birth
          new_patient.patient_email = patient.patient_email
          new_patient.patient_phone = patient.patient_phone
          new_patient.patient_coverage_id = patient.patient_coverage_id
          new_patient.healthcare_coverage = patient.healthcare_coverage
          new_patient.patient_address = patient.patient_address
          new_patient.mode_of_contact = patient.mode_of_contact
          new_patient.patient_zipcode = patient.patient_zipcode
          new_patient.patient_status = patient.patient_status
          new_patient.gender = patient.gender
          new_patient.race = patient.race
          new_patient.ethnicity = patient.ethnicity
          #
          new_patient.security_keys =  helpers.security_keys_for_patients(new_patient)
          logger.debug("NEW PATIENT IS #{new_patient.inspect}")
          new_patient.save

          logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")

                if new_patient.security_keys.length > 0 || task.security_keys.length > 0 
                    #logger.debug("patient details #{patient.inspect}******* task details #{task.inspect}")
                        # if client_application.agreement_type == external_application.agreement_type
                            #logger.debug("client_application #{client_application.inspect}")
                              #logger.debug("external_application #{external_application.inspect}")
                             if !client_application.client_agreement.url.nil? && !external_application.client_agreement.url.nil?
                                send_task(new_patient.id.to_s, task,external_application_id, existing_status, patient)
                             else 
                              #Do Not Send: Email: Sorry, the agreement types do not match
                              SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                             end
                        # else
                        #     #Do Not Sent: Email: Sorry, you still need to sign your Agreement or more.
                        #     SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                        # end
                else 
                    send_task(new_patient.id.to_s, task,external_application_id, existing_status, patient)
                end 

        else
          logger.debug("the patient IS ALREADY PRESENT************* #{patient.inspect} ******** #{task.inspect}")

                if patient.security_keys.length > 0  || task.security_keys.length > 0 
                    #logger.debug("patient details #{patient.inspect}******* task details #{task.inspect}")

                            logger.debug("client_application #{client_application.inspect}")
                            logger.debug("external_application #{external_application.inspect}")
                        # if client_application.agreement_type == external_application.agreement_type
                            #logger.debug("client_application #{client_application.inspect}")
                              #logger.debug("external_application #{external_application.inspect}")
                             if !client_application.client_agreement.url.nil? && !external_application.client_agreement.url.nil?
                                send_task(patient_check.id.to_s, task,external_application_id, existing_status, patient)
                             else 
                              #Do Not Send: Email: Sorry, the agreement types do not match
                              SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                             end 
                        # else
                            #Do Not Sent: Email: Sorry, you still need to sign your Agreement or more.
                            # SendPatientTaskMailer.patient_not_sent(external_application.users.first.email).deliver
                        # end
                else 
                    logger.debug("NIL NIL NIL NIL NIL NIL NIL")
 
                    send_task(patient_check.id.to_s, task,external_application_id, existing_status, patient)
                end 

        end

      end


    end


    def send_task(p_id, task, ea_id, ledg_stat, old_patient)
      logger.debug("SENDING TASK TO EXTERNAL APPLICATION*************** #{p_id}, -----task is : #{task.inspect}")

      external_application = ClientApplication.find(ea_id)

      if external_application.external_application == true
        external_api = ExternalApiSetup.where(client_application_id: ea_id, api_for: "remove_patient").first

        task_hash = Hash.new
        task_hash["patient_id"] = p_id
        external_api.mapped_parameters.each do|mp|
          external_parameter = mp.external_parameter
          chc_parameter = mp.chc_parameter # first_name
          chc_value = task[chc_parameter]
          task_hash[external_parameter] = chc_value

          logger.debug("the parameter value is : EXTERNAL:  #{external_parameter}, CHC : #{chc_parameter} -----#{chc_value}")
        end

        logger.debug("the task hash is : #{task_hash}")


        input = {"task_hash": task_hash}
        uri = URI("http://localhost:3001/api/add_external_tasks")


        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
        # http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, header)
        request.body = input.to_json

        # Send the request
        response = http.request(request)
        puts "response #{response.body}"
        puts JSON.parse(response.body)
        result = JSON.parse(response.body)
        logger.debug("the patient id is : #{result}")
      else

        logger.debug("Creating REFERRAL FOR INTERNAL APPLICATION********************")
        r = Referral.new
        r.client_application_id = ea_id
        r.patient_id = p_id
        #need a patient !!!
        patient = Patient.find(p_id)
        
        r.referral_name = "Test"
        if r.save
          logger.debug("Creating TASK FOR INTERNAL APPLICATION*************************")
          t = Task.new
          t.referral_id = r.id.to_s
          t.task_type = task.task_type
          t.task_status = task.task_status
          t.task_deadline = task.task_deadline
          t.task_description = task.task_description
          t.additional_fields = task.additional_fields
          t.task_referred_from = ledg_stat.referred_by_id
          t.security_keys = helpers.security_keys_for_task(task, patient)
          if t.save
            ledg_stat.ledger_status = "Transferred"
            ledg_stat.external_object_id = t.id.to_s
            ledg_stat.save
            ledger_master = LedgerMaster.new
            ledger_master.task_id = t.id.to_s
            ledger_master.patient_id = p_id
            if ledger_master.save
              ledger_status = LedgerStatus.new
              ledger_status.referred_application_id = ea_id
              ledger_status.referred_by_id = old_patient.client_application_id.to_s
              ledger_status.external_object_id = task.id
              ledger_status.ledger_status = "Accepted"
              ledger_status.ledger_master_id = ledger_master.id.to_s
              ledger_status.save
            end
          end

          render :json=> {status: :ok, message: "Patient and Task were transferred successfully " }
        end
      end
    end

    def client_list
      #all_client = ClientApplication.where(accept_referrals: true)
      all_client = ClientApplication.all
      all_client_array = []
      all_client.each do |ac|
        name = ac.name
        id =  ac.id.to_s
        speciality = ac.client_speciality
        agreement_type = ac.agreement_type
        agreement_signed = ac.agreement_signed
        client_hash = {name: name, id: id, speciality: speciality, agreement_signed: agreement_signed, agreement_type: agreement_type}
        all_client_array.push(client_hash)
      end

      # logger.debug("the list of the client is: #{all_client_array}")
      render :json=> {status: :ok, client_list: all_client_array.sort_by{|h| h[:name].downcase} }
    end


    def send_referral
      task_id = params[:task_id]
      referred_by_id = Task.find(params[:task_id]).referral.client_application.id.to_s
      ledger_master = LedgerMaster.where(task_id: task_id).first
      ledger_master_id = ledger_master.id.to_s
      referred_applicaiton = ClientApplication.find(params[:referred_application_id])
      client_user = referred_applicaiton.users.first
      client_user_email = client_user.email

      exixting_status= ledger_master.ledger_statuses.where(referred_application_id: params[:referred_application_id] )
      logger.debug("the existing status value is : #{exixting_status.entries}")

      if !exixting_status.empty?
        logger.debug("the IF BLOCK OF EXISTING***************")
      else
        logger.debug("the ELSE BLOCK OF EXISTING***************")

        logger.debug("the user is #{client_user}, ******** USER EMAIL IS : #{client_user_email}")
        led_stat = LedgerStatus.new
        led_stat.referred_application_id = params[:referred_application_id]
        led_stat.ledger_master_id = ledger_master_id
        led_stat.ledger_status = "Pending"
        led_stat.referred_by_id = referred_by_id
        if led_stat.save
          logger.debug("NOTIFICATION FOR REFERAL WILL BE SENT**********")
          RegistrationRequestMailer.referral_request(client_user_email,task_id, params[:referred_application_id] ).deliver
          render :json=> {status: :ok, message: "Referral Request was sent" }
        end
      end

    end

    def referred_app_name
      client_name_array = []
      ledger_status = LedgerMaster.where(task_id: params[:task_id]).first.ledger_statuses
      ledger_status.each do |led_stat|
        client = ClientApplication.find(led_stat.referred_application_id)
        client_name_array.push(client.name)
      end

      render :json=> {status: :ok, client_name_array: client_name_array }
    end

    def in_coming_referrals
      in_rfl_array = []
      user = User.find_by(email: params[:email])
      client_application = user.client_application.id.to_s
      incoming_referrals = LedgerStatus.where(referred_application_id: client_application)
      incoming_referrals.each do |in_rfl|
        referred_from = ClientApplication.find(in_rfl.referred_by_id).name
        task_id = in_rfl.ledger_master.task_id
        task_description = Task.find(task_id).task_description
        t_id = Task.find(task_id).id.to_s
        patient = Task.find(task_id).referral.patient
        patient_name = patient.last_name + " "+  patient.first_name
        p_first_name = patient.first_name
        p_last_name = patient.last_name
        in_rfl_status = in_rfl.ledger_status
        ref = Task.find(task_id).referral
        ref_name = ref.referral_name + "- Copy"
        ref_source = ref.source
        ref_urgency = ref.urgency
        in_rfl_hash = {referred_from: referred_from,task_id:t_id, task_description: task_description, status: in_rfl_status,
                       external_application_id: in_rfl.referred_application_id,patient_name: patient_name,ref_name: ref_name,
                       ref_source: referred_from,ref_urgency: ref_urgency, p_last_name: p_last_name, p_first_name: p_first_name,
                       submission_date: in_rfl.created_at.strftime('%m/%d/%Y') }
        in_rfl_array.push(in_rfl_hash)
      end
      render :json=> {status: :ok, incoming_referrals: in_rfl_array.sort_by{|h| h[:submission_date]}.reverse  }
    end

    def out_going_referrals
      out_rfl_array = []
      outgoing_referrals = LedgerStatus.where(referred_by_id: params[:application_id])
      outgoing_referrals.each do |out_rfl|
        referred_to = ClientApplication.find(out_rfl.referred_application_id).name
        task_id = out_rfl.ledger_master.task_id
        task_description = Task.find(task_id).task_description
        out_rfl_status = out_rfl.ledger_status
        out_rfl_hash = {referred_to: referred_to, task_description: task_description, status: out_rfl_status }
        out_rfl_array.push(out_rfl_hash)
      end

      render :json=> {status: :ok, outgoing_referrals: out_rfl_array  }
    end

    def new_ledger_record
      task_id = params[:task_id]
      task = Task.find(task_id)
      ledgger_master = LedgerMaster.where(task_id: task_id).first
      ledger_status = ledgger_master.ledger_statuses.first
      lr = LedgerRecord.new
      lr.ledger_status_id = ledger_status.id.to_s
      lr.changed_fields = params[:changed_fields].to_unsafe_h
      lr.save
      # lr.ledger_status_id =

    end

    def ledger_record_list


    end

    def ledger_details
      task_id =  params[:task_id]
      ledger_master = LedgerMaster.where(task_id: task_id).first
      user = User.find_by(email:params[:email])
      #external_application_id = user.client_application_id.to_s
      # ledger_status= ledger_master.ledger_statuses.where(referred_application_id: external_application_id ).first
      ledger_status= ledger_master.ledger_statuses.first
      referred_by_id = ledger_status.referred_by_id
      #referred_by = ClientApplication.find(referred_by_id).name
      internal_record_array = []
      internal_records = ledger_status.ledger_records
      internal_records.each do |ir|
        changes = ir.changed_fields
        first_hash = {}
        second_hash = {}
        changes_array = []
        changes.keys.each do |k|
          if changes[k][1] != ""
            first_hash[k] = changes[k][0]
            second_hash[k] = changes[k][1]
          end
        end
        changes_array.push(first_hash)
        changes_array.push(second_hash)
        created_at = ir.created_at.strftime("%D %T")
        internal_record_hash = {changes: changes_array, created_at: created_at}
        internal_record_array.push(internal_record_hash)
      end

      external_record_array = []
      external_status = LedgerStatus.where(external_object_id: task_id ).first
      if !external_status.nil?
        external_records = external_status.ledger_records if !external_status.nil?

        external_records.each do |er|
          changes = er.changed_fields
          first_hash = {}
          second_hash = {}
          changes_array = []
          changes.keys.each do |k|
            if changes[k][1] != ""
              first_hash[k] = changes[k][0]
              second_hash[k] = changes[k][1]
            end
          end
          changes_array.push(first_hash)
          changes_array.push(second_hash)
          created_at = er.created_at.strftime("%D %T")
          external_record_hash = {changes: changes_array, created_at: created_at}
          external_record_array.push(external_record_hash)
        end
      end

      render :json => {status: :ok, ledger_details: {internal_record_array: internal_record_array, external_record_array: external_record_array } }

    end


  end
end
