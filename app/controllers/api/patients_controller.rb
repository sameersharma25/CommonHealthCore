module Api
  class PatientsController < ActionController::Base




    def update_patient
      patient = Patient.find(params[:patient_id])
      patient.first_name = params[:first_name] if params[:first_name]
      patient.last_name = params[:last_name] if params[:last_name]
      patient.date_of_birth = params[:date_of_birth] if params[:date_of_birth]
      patient.patient_email = params[:patient_email] if params[:patient_email]
      patient.patient_phone = params[:patient_phone] if params[:patient_phone]
      patient.patient_coverage_id = params[:patient_coverage_id] if params[:patient_coverage_id]
      patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
      patient.mode_of_contact = params[:mode_of_contact] if params[:mode_of_contact]
      patient.patient_zipcode = params[:patient_zipcode] if params[:patient_zipcode]
      patient.ethnicity = params[:ethnicity] if params[:ethnicity]
      patient.gender = params[:gender] if params[:gender]
      patient.patient_address = params[:patient_address] if params[:patient_address]
      patient.save

      patient_name = patient.first_name+" "+ patient.last_name
      render :json => {status: :ok, message: "#{patient_name} Details have been updated" }
    end



    def crete_appointment_for_patient

      user = User.find_by(email: params[:email])
      client_application = user.client_application
      if user.cc == true
        cc_id = user.id.to_s
      else
        cc_id = client_application.users.where(cc: true).last.id.to_s
      end
      patient = Patient.find(params[:patient_id])
      patient_name = patient.first_name + " "+ patient.last_name

      a = Appointment.new
      a.date_of_appointment = params[:date_of_appointment]
      a.reason_for_visit = params[:reason_for_visit] ? params[:reason_for_visit] : " "
      a.status = "New"
      a.user_id = user
      a.client_application_id = client_application
      a.patient_id = patient
      a.cc_id = cc_id
      a.notes = params[:note] if params[:note]
      if a.save
        render :json=> {status: :ok, message: "Appointment Created for #{patient_name}"}
      end
    end

    def create_patient
      user = User.find_by(email: params[:email])
      client_application = user.client_application

      patient = Patient.new
      patient.client_application_id = client_application
      patient.first_name = params[:first_name] if params[:first_name]
      patient.last_name = params[:last_name] if params[:last_name]
      patient.date_of_birth = params[:date_of_birth] if params[:date_of_birth]
      patient.patient_email = params[:patient_email] if params[:patient_email]
      patient.patient_phone = params[:patient_phone] if params[:patient_phone]
      patient.patient_coverage_id = params[:patient_coverage_id] if params[:patient_coverage_id]
      patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
      patient.mode_of_contact = params[:mode_of_contact] if params[:mode_of_contact]
      patient.patient_zipcode = params[:patient_zipcode] if params[:patient_zipcode]
      patient.ethnicity = params[:ethnicity] if params[:ethnicity]
      patient.gender = params[:gender] if params[:gender]
      patient.patient_status = "New"
      if patient.save
        render :json=> {status: :ok, message: "Patient Created Successfully"}
      end
    end



  end
end
