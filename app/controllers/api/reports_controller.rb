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

      patients = Patient.where(patient_created_by: @user_id)

      patients_count = patients.count

      render :json => {status: :ok, patients: patients, patients_count: patients_count  }
    end

    def assessment_created_by_a_navigator

      # user = User.find_by(email: params[:email])
      # user_id = user.id.to_s

      client_application_id = User.find_by(email: params[:email]).client_application_id
      referrals = Referral.where(client_application_id: client_application_id, referral_type: "Interview", ref_created_by: @user_id  )

      interview_list = helpers.assessments_list(referrals)
      interview_count = interview_list.count
      render :json => {status: :ok, interview_list: interview_list, interview_count: interview_count }

    end

    def task_transferred_by_navigator

      out_rfl_array = []
      outgoing_referrals = LedgerStatus.where(transferred_by: @user_id)
      outgoing_referrals.each do |out_rfl|
        referred_to = ClientApplication.find(out_rfl.referred_application_id).name
        task_id = out_rfl.ledger_master.task_id
        task_description = Task.find(task_id).task_description
        out_rfl_status = out_rfl.ledger_status
        out_rfl_hash = {referred_to: referred_to, task_description: task_description, status: out_rfl_status }
        out_rfl_array.push(out_rfl_hash)
      end

      render :json=> {status: :ok, outgoing_referrals: out_rfl_array, outgoing_referrals_count: out_rfl_array.count }

    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_id
      user = User.find_by(email: params[:email])
      @user_id = user.id.to_s
    end
  end
end