module Api
  class ReportsController < ActionController::Base
    include UsersHelper

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

      interview_list = assessments_list(referrals)
      interview_count = interview_list.count
      render :json => {status: :ok, interview_list: interview_list, interview_count: interview_count }

    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_id
      user = User.find_by(email: params[:email])
      @user_id = user.id.to_s
    end
  end
end