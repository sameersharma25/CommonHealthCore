module Api
  class ReportsController < ActionController::Base
    include UsersHelper

    before_action :authenticate_user_from_token, except: []
    load_and_authorize_resource class: :api, except: []

    def number_of_clients_created_by_a_navigator
      user = User.find_by(email: params[:email])
      user_id = user.id.to_s

      patients = Patient.where(created_by: user_id)

      patients_count = patients.count

      render :json => {status: :ok, patients: patients, patients_count: patients_count  }
    end

    def assessment_created_by_a_navigator


    end
  end
end