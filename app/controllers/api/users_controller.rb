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
      p.patient_phone = "+1"+params[:patient_phone]
      p.healthcare_coverage = params[:healthcare_coverage]
      p.patient_coverage_id = params[:patient_coverage] if params[:patient_coverage]
      p.client_application_id = client_application
      p.date_of_birth = params[:dob]
      p.patient_zipcode = params[:zipcode]
      p.patient_email = params[:patient_email]
      if p.save
        a = Appointment.new
        a.date_of_appointment = params[:date_of_appointment]
        a.reason_for_visit = params[:reason_for_visit] ? params[:reason_for_visit] : " "
        a.status = "New"
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
        referred_by = a.user.email
        reason_for_visit = a.reason_for_visit
        date_of_appointment = a.date_of_appointment
        details_array = {appointment_id: appointment_id, patient_name: patient_name,
                         patient_dob: patient_dob, appointment_status: appointment_status,
                          referred_by: referred_by, rov: reason_for_visit, date_of_appointment: date_of_appointment }
        appointments_array.push(details_array)
        logger.debug("AFTER THE PUSH**********")
      end

      render :json => {status: :ok, details_array: appointments_array }
    end

    def appointments_referred_to_me
      user = User.find_by(email: params[:email])
      logger.debug("THE USER IS #{user.inspect}")
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
                                                        patient_phone_number: patient.patient_phone,
                                                        patient_email: patient.patient_email,
                                                        patient_coverage: patient.patient_coverage_id,
                                                        appointment_date: appointment.date_of_appointment,
                                                        reason_for_visit: appointment.reason_for_visit,
                                                        status: appointment.status
        }
      }

    end

    def update_appointment
      a = Appointment.find(params[:appointment_id])
      user = User.find_by(email: params[:email])
      patient = a.patient
      patient.first_name = params[:first_name]
      patient.last_name = params[:last_name] if !params[:last_name].nil?
      patient.patient_phone = params[:patient_phone]
      patient.date_of_birth = params[:dob]
      patient.healthcare_coverage = params[:healthcare_coverage]
      a.date_of_appointment = params[:date_of_appointment]
      a.reason_for_visit = params[:reason_for_visit]
      a.status = "Edit"
      a.save
      render :json=> {status: :ok, message: "Appointment Updated"}
    end

    def give_appointment_details_for_notification
      # logger.debug("THE PARAMETERS ARE : #{params.inspect}")
      # a = Appointment.find(params["appointment_id"])
      # patient = a.patient
      # status = a.status
      # patient_email = patient.patient_email
      # patient_phone = patient.patient_phone
      # patient_name = patient.first_name+" "+patient.last_name
      # cc_email = User.find(a.cc_id).email
      # logger.debug("BEFORE NOTIFICATION RULE*******************#{status}")

      td_hrs = params["td_hrs"]
      notification_details = selected_rules(params["appointment_id"] ,td_hrs)

      # NotificationRule.create(appointment_status: "New", time_difference: 48, greater: false, subject: "some subject for PCP", body: "Some message for PCP", client_application_id: c, user_type: "pcp" )
      # notification_response = Hash.new

      # notification = NotificationRule.where(:appointment_status => status, :appointment_time_passed => params["td_hrs"])
      # logger.debug("After NOTIFICATION RULE******************* #{notification.entries}")
      # subject = notification[0].subject
      # body = notification[0].body

      render :json => {status: :ok , notification_details: notification_details  }
    end


    def patients_list
      user = User.find_by(email: params[:email])
      c = user.client_application_id
      patients = Patient.where(client_application_id: c)
      patients_details = Array.new

      patients.each do |p|
        patient_id = p.id.to_s
        first_name = p.first_name
        last_name = p.last_name
        ph_number = p.patient_phone
        patient_detail = {patient_id: patient_id, first_name: first_name, last_name: last_name, ph_number: ph_number }
        patients_details.push(patient_detail)
      end

      render :json => {status: :ok, patients_details: patients_details }
    end

    def patient_appointments
      p = Patient.find(params[:patient_id])
      appointments = p.appointments.order(created_at: :desc).limit(10)
      appointments_array = Array.new

      patient_name = p.first_name+" "+p.last_name
      
      appointments.each do |a|
        logger.debug("the APPOINTMENR IS : #{a.id.inspect} ******************************")
        patient = a.patient
        appointment_id = a.id.to_s
        patient_name = patient.first_name+" "+patient.last_name
        patient_dob = patient.date_of_birth
        appointment_status = a.status
        referred_by = a.user.email
        reason_for_visit = a.reason_for_visit
        date_of_appointment = a.date_of_appointment
        details_array = {appointment_id: appointment_id, patient_name: patient_name,
                         patient_dob: patient_dob, appointment_status: appointment_status,
                         referred_by: referred_by, rov: reason_for_visit, date_of_appointment: date_of_appointment }
        appointments_array.push(details_array)
        logger.debug("AFTER THE PUSH**********")
      end

      render :json => {status: :ok, patient_name: patient_name ,details_array: appointments_array }

    end

  end
end
