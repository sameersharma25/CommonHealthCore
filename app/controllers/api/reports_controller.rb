module Api
  class ReportsController < ActionController::Base
    include UsersHelper
    include InterviewsHelper

    before_action :set_user_id
    before_action :authenticate_user_from_token, except: []
    load_and_authorize_resource class: :api, except: []

    def clients_created_by_a_navigator
      # user = User.find_by(email: params[:email])
      # user_id = user.id.to_s

      all_patient_array = []
      patient_created_by_me = HistoryTracker.where(scope: "patient", action: "create" ,  modifier_id: current_user.id.to_s)

      if !params[:date_filter].blank?
        patient_created_by_me = data_filtering(patient_created_by_me)
      end

      patient_created_by_me.each do |pc|
        patient_id = pc.association_chain[0]["id"].to_s
        patient = Patient.find(patient_id)
        patient_name = patient.last_name + " " + patient.first_name
        created_on = pc.created_at.strftime("%D")
        patient_hash = {patient_name: patient_name, created_on: created_on }
        all_patient_array.push(patient_hash)
      end

      # patients = Patient.where(patient_created_by: @user_id)
      # patients_count = patients.count

      render :json => {status: :ok, all_patient_array: all_patient_array  }
    end

    def assessment_created_by_a_navigator

      # user = User.find_by(email: params[:email])
      # user_id = user.id.to_s

      assessment_array = []
      assessment_created_by_me = HistoryTracker.where(scope: "referral", action: "create" ,  modifier_id: current_user.id.to_s)
      if !params[:date_filter].blank?
        assessment_created_by_me = data_filtering(assessment_created_by_me)
      end
      assessment_created_by_me.each do |ac|
        ref_id = ac.association_chain[0]["id"].to_s
        ref = Referral.find(ref_id)
        if ref.referral_type == "Interview"
          patient_id = ref.patient.id.to_s
          patient = Patient.find(patient_id)
          ref_name = ref.referral_name
          caller_first_name = patient.last_name + " "+ patient.first_name
          created_on = ac.created_at.strftime("%D")
          assessment_hash = {created_on: created_on, caller_first_name: caller_first_name, ref_name: ref_name }
          assessment_array.push(assessment_hash)
        end

      end
      # client_application_id = User.find_by(email: params[:email]).client_application_id
      # referrals = Referral.where(client_application_id: client_application_id, referral_type: "Interview", ref_created_by: @user_id  )
      #
      # interview_list = helpers.assessments_list(referrals)
      # interview_count = interview_list.count
      render :json => {status: :ok, interview_list: assessment_array}

    end

    def task_transferred_by_navigator

      out_rfl_array = []
      task_tranferred_by_me = HistoryTracker.where(scope: "ledger_status", action: "create" ,  modifier_id: current_user.id.to_s)

      if !params[:date_filter].blank?
        task_tranferred_by_me = data_filtering(task_tranferred_by_me)
      end

      task_tranferred_by_me.each do |tt|
        if tt["modified"].keys.include?("ledger_status")
          if tt["modified"]["ledger_status"] == "Pending"
            led_status_id = tt.association_chain[0]["id"].to_s
            led_status = LedgerStatus.find(led_status_id)

            referred_to = ClientApplication.find(led_status.referred_application_id).name
            task_id = led_status.ledger_master.task_id
            task = Task.find(task_id)
            ref_name = task.referral.referral_name
            patient = task.referral.patient
            patient_name = patient.last_name + " " + patient.first_name
            task_description = task.task_description
            out_rfl_status = led_status.ledger_status
            out_rfl_hash = {referred_to: referred_to, patient_name: patient_name,ref_name: ref_name, task_description: task_description, status: out_rfl_status }
            out_rfl_array.push(out_rfl_hash)
          end
        end
      end

      # outgoing_referrals = LedgerStatus.where(transferred_by: @user_id)
      # outgoing_referrals.each do |out_rfl|
      #   referred_to = ClientApplication.find(out_rfl.referred_application_id).name
      #   task_id = out_rfl.ledger_master.task_id
      #   task_description = Task.find(task_id).task_description
      #   out_rfl_status = out_rfl.ledger_status
      #   out_rfl_hash = {referred_to: referred_to, task_description: task_description, status: out_rfl_status }
      #   out_rfl_array.push(out_rfl_hash)
      # end

      render :json=> {status: :ok, outgoing_referrals: out_rfl_array, outgoing_referrals_count: out_rfl_array.count }

    end



    def requests_accepted_by_navigator

      out_rfl_array = []
      request_accepted_by_me = HistoryTracker.where(scope: "ledger_status", action: "update" ,  modifier_id: current_user.id.to_s)

      if !params[:date_filter].blank?
        request_accepted_by_me = data_filtering(request_accepted_by_me)
      end

      request_accepted_by_me.each do |tt|
        if tt["modified"].keys.include?("ledger_status")
          if tt["modified"]["ledger_status"] == "Transferred"
            led_status_id = tt.association_chain[0]["id"].to_s
            led_status = LedgerStatus.find(led_status_id)

            referred_to = ClientApplication.find(led_status.referred_application_id).name
            task_id = led_status.ledger_master.task_id
            task = Task.find(task_id)
            ref_name = task.referral.referral_name
            patient = task.referral.patient
            patient_name = patient.last_name + " " + patient.first_name
            task_description = task.task_description
            out_rfl_status = led_status.ledger_status
            out_rfl_hash = {referred_to: referred_to, patient_name: patient_name,ref_name: ref_name, task_description: task_description, status: out_rfl_status }
            out_rfl_array.push(out_rfl_hash)
          end
        end
      end

      render :json=> {status: :ok, outgoing_referrals: out_rfl_array, outgoing_referrals_count: out_rfl_array.count }

    end

    def requests_rejected_by_navigator

      out_rfl_array = []
      request_rejected_by_me = HistoryTracker.where(scope: "ledger_status", action: "update" ,  modifier_id: current_user.id.to_s)

      if !params[:date_filter].blank?
        request_rejected_by_me = data_filtering(request_rejected_by_me)
      end

      request_rejected_by_me.each do |tt|
        if tt["modified"].keys.include?("ledger_status")
          if tt["modified"]["ledger_status"] == "Rejected"
            led_status_id = tt.association_chain[0]["id"].to_s
            led_status = LedgerStatus.find(led_status_id)

            referred_to = ClientApplication.find(led_status.referred_application_id).name
            task_id = led_status.ledger_master.task_id
            task = Task.find(task_id)
            ref_name = task.referral.referral_name
            patient = task.referral.patient
            patient_name = patient.last_name + " " + patient.first_name
            task_description = task.task_description
            out_rfl_status = led_status.ledger_status
            out_rfl_hash = {referred_to: referred_to, patient_name: patient_name,ref_name: ref_name, task_description: task_description, status: out_rfl_status }
            out_rfl_array.push(out_rfl_hash)
          end
        end
      end

      render :json=> {status: :ok, outgoing_referrals: out_rfl_array, outgoing_referrals_count: out_rfl_array.count }

    end

    def organizations_referred_by_my_organization

      customer_id = current_user.client_application.id.to_s

      request_sent_by_my_org = LedgerStatus.where(referred_by_id: customer_id)

      if !params[:date_filter].blank?
        request_sent_by_my_org = data_filtering(request_sent_by_my_org)
      end

      request_sent_by_my_org = request_sent_by_my_org.pluck(:referred_application_id).group_by(&:itself).map{|k, v| [k, v.length]}

      organizaiton_hash_array = []

      request_sent_by_my_org.each do |rso|
        client_name = ClientApplication.find(rso[0]).name
        client_hash = {client_name: client_name, count: rso[1]}
        organizaiton_hash_array.push(client_hash)
      end

      render :json=> {status: :ok, organizaiton_hash_array: organizaiton_hash_array }
    end

    def organizations_referred_to_my_organization

      customer_id = current_user.client_application.id.to_s

      request_sent_by_my_org = LedgerStatus.where(referred_application_id: customer_id)


      if !params[:date_filter].blank?
        request_sent_by_my_org = data_filtering(request_sent_by_my_org)
      end

      request_sent_by_my_org = request_sent_by_my_org.pluck(:referred_by_id).group_by(&:itself).map{|k, v| [k, v.length]}

      organizaiton_hash_array = []

      request_sent_by_my_org.each do |rso|
        client_name = ClientApplication.find(rso[0]).name
        client_hash = {client_name: client_name, count: rso[1]}
        organizaiton_hash_array.push(client_hash)
      end

      render :json=> {status: :ok, organizaiton_hash_array: organizaiton_hash_array }
    end

    def data_filtering(data)
      if params[:duration] == "monthly"
        filtered_hash = monthly_report(params[:date_filter], data )
      elsif params[:duration] == "quarterly"
        filtered_hash = quarterly_report(params[:date_filter], data )
      elsif params[:duration] == "yearly"
        filtered_hash = yearly_report(params[:date_filter], data )
      end
      filtered_hash
    end

    def monthly_report(date, data_hash)
      start_date = Date.parse(date).beginning_of_month
      end_date = Date.parse(date).end_of_month

      new_data =  data_hash.where(created_at: start_date..end_date)
    end

    def quarterly_report(date, data_hash)
      start_date = Date.parse(date).beginning_of_quarter
      end_date = Date.parse(date).end_of_quarter

      new_data =  data_hash.where(created_at: start_date..end_date)
    end

    def yearly_report(date, data_hash)
      start_date = Date.parse(date).beginning_of_year
      end_date = Date.parse(date).end_of_year

      new_data =  data_hash.where(created_at: start_date..end_date)
    end



    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_id
      user = User.find_by(email: params[:email])
      @user_id = user.id.to_s
    end
  end
end