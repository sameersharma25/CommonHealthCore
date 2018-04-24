module Api
  class UsersController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:give_appointment_details_for_notification]

    def get_all_users
      logger.debug("the user email you sent is : #{params[:email]}")
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      client_all_users = client_application.users
      users_details_array = Array.new

      client_all_users.each do |u|
        uname = u.name
        uemail = u.email
        ucc = u.cc
        upcp = u.pcp
        user_derails = {name: uname, email: uemail, cc: ucc, pcp: upcp }
        users_details_array.push(user_derails)
      end

      render :json=> {status: :ok, :users_data=> users_details_array }

      # resource = User.find_for_database_authentication(:email=>params[:email])
      # return invalid_login_attempt unless resource

      # if resource.valid_password?(params[:password])
      #   # sign_in("user", resource)
      #   user = User.find_by_email(params[:email])
      #   render :json=> {status: :ok,message: "Login Successful", data: {:user_id=>user.id.to_s, :auth_token => user.api_token}}
      #   return
      # end

    end

    def create_appointment
      logger.debug("")
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      if user.cc == true
        cc_id = user.id.to_s
      else
        cc_id = client_application.users.where(cc: true).last.id.to_s
      end

      p = Patient.new
      p.last_name = params[:last_name]
      p.first_name = params[:first_name]
      p.patient_phone = params[:patient_phone]
      p.patient_coverage = params[:patient_coverage] if params[:patient_coverage]
      p.client_application_id = client_application
      if p.save
        a = Appointment.new
        a.date_of_appointment = params[:date_of_appointment]
        a.reason_for_visit = params[:reason_for_visit]
        a.status = params[:status]
        a.user_id = user
        a.client_application_id = client_application
        a.patient_id = p
        a.cc_id = cc_id
        if a.save
          render :json=> {status: :ok, message: "Appointment Created"}
        end
      else
        render :json => {status: :bad_request, message: "Check all patient details"}
      end
    end

    def get_user_appointments
      user = User.find_by(email: params[:email])
      user_id = user.id.to_s
      logger.debug("THE USER ID IS : #{user_id}")
      appointments = Appointment.or({user_id: user},{cc_id: user_id })
      appointments_array = Array.new

      appointments.each do |a|
        logger.debug("the APPOINTMENR IS : #{a.id.inspect} ******************************")
        patient = a.patient
        appointment_id = a.id.to_s
        patient_name = patient.first_name+" "+patient.last_name
        patient_dob = patient.date_of_birth
        appointment_status = a.status
        details_array = {appointment_id: appointment_id, patient_name: patient_name, patient_dob: patient_dob, appointment_status: appointment_status }
        appointments_array.push(details_array)
        logger.debug("AFTER THE PUSH**********")
      end

      render :json => {status: :ok, details_array: appointments_array }
    end

    def appointments_referred_to_me
      user = User.find_by(email: params[:email])
      if user.pcp == true
        service_provider_id = user.service_provider_id
        appointments_array = Array.new
        appointments = Appointment.where(service_provider_id: service_provider_id)
        appointments.each do |a|
          logger.debug("the APPOINTMENR IS : #{a.id.inspect} ******************************")
          patient = a.patient
          appointment_id = a.id.to_s
          patient_name = patient.first_name+" "+patient.last_name
          patient_dob = patient.date_of_birth
          appointment_status = a.status
          details_array = {appointment_id: appointment_id, patient_name: patient_name, patient_dob: patient_dob, appointment_status: appointment_status }
          appointments_array.push(details_array)
          logger.debug("AFTER THE PUSH**********")
        end

        render :json => {status: :ok, details_array: appointments_array }
      end

    end

    def create_user
      user = User.find_by(email: params[:email])
      client_application = user.client_application

      email = params[:user_email]
      name = params[:user_name]
      cc = params[:cc]
      pcp = params[:pcp]

      @user = User.invite!(email: email)
      if @user.update(client_application_id: client_application ,cc: cc, pcp: pcp, name: name )
        render :json => {status: :ok, message: "User was successfully Invited."}
      else
        render :json => {status: :bad_request, message: "There was some problem creating user."}
      end
    end

    def edit_appointment

      appointment = Appointment.find(params[:appointment_id])
      logger.debug("EDITING APPOINTMENT -: #{appointment.inspect}")
      patient = appointment.patient


      render :json => {status: :ok, appointment_hash: { first_name: patient.first_name, last_name: patient.last_name,
                                                        phone_number: patient.patient_phone,
                                                        coverage: patient.patient_coverage,
                                                        appointment_date: appointment.date_of_appointment,
                                                        reason_for_visit: appointment.reason_for_visit,
                                                        status: appointment.status
        }
      }

    end

    def update_appointment
      a = Appointment.find(params[:appointment_id])
      user = User.find_by(email: params[:email])
      a.date_of_appointment = params[:date_of_appointment]
      a.reason_for_visit = params[:reason_for_visit]
      a.status = "Edit"
      a.save
      render :json=> {status: :ok, message: "Appointment Updated"}
    end

    def give_appointment_details_for_notification

      a = Appointment.find(params[:appointments_id])
      patient = a.patient
      status = a.status
      patient_email = patient.email
      patient_name = patient.first_name+" "+patient.last_name
      cc_email = User.find(a.cc_id).email
      

      render :json => {status: :ok , patient_email: patient_email, patient_name: patient_name, cc_email: cc_email  }
    end

  end
end
