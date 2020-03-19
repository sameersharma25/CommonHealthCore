module Api
  class UsersController < ActionController::Base
    include UsersHelper
    require 'securerandom'
    before_action :authenticate_user_from_token, except: [:forgot_password,:get_terms,:get_about_us,:get_faq,:give_appointment_details_for_notification,  :set_password, :chcAuthentication]
    # before_action :authenticate_user!
    load_and_authorize_resource class: :api, except: [:forgot_password,:get_terms,:get_about_us,:get_faq,:give_appointment_details_for_notification, :chcAuthentication]

    #skip_before_action :verify_authenticity_token, only: [:chcAuthentication]

    def get_all_users
      logger.debug("the user email you sent is : #{params[:email]}")
      user = User.find_by(email: params[:email])
      client_application = user.client_application
      client_all_users = client_application.users
      users_details_array = Array.new

      client_all_users.each do |u|
        uid = u.id.to_s
        uname = u.name
        uemail = u.email
        ucc = u.cc
        upcp = u.pcp
        user_details = {id: uid, name: uname, email: uemail, cc: ucc, pcp: upcp }
        users_details_array.push(user_details)
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

    def change_user_password
      logger.debug("In here #{params}")
      user = User.find_by(email: params[:email])
      
      if user&.valid_password?(params[:password])
        user.password = params['new_password']
        user.save! 
        if user.save
            render :json =>{status: :ok, message: "Password Updated"}
        end 
      end 
    end 

    def get_theme
      user = User.find_by(email: params[:email])
      current_theme = user.client_application.theme
      render :json => {status: :ok, themes: ClientApplication::THEME, user_theme: current_theme}

    end 

    def set_theme
      user = User.find_by(email: params[:email])
      user.client_application.theme = params['theme']
      user.save 
      if user.save
         render :json=> {status: :ok, message: "Theme Set"}
       end 
    end

    api :POST, "/create_appointment", "Create Appointment"
    param :email, String, :desc => "User Email", :required => true
    param :first_name, String, :desc => "Patient first name", :required => true
    param :last_name, String, :desc => "Patient last name", :required => true
    param :patient_phone, String, :desc => "Patient phone"
    param :reason_for_visit, String, :desc => "Reason for visit"
    param :patient_coverage, String
    param :dob, String
    param :healthcare_coverage, String
    def create_appointment
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

                                                        date_of_birth: patient.date_of_birth,
                                                        patient_zip: patient.patient_zipcode,
                                                        patient_address: patient.patient_address,
                                                        gender: patient.gender,
                                                        ethnicity: patient.ethnicity,
                                                        notes: appointment.notes,

                                                        mode_of_contact: patient.mode_of_contact,
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
      # patient.first_name = params[:first_name] if params[:first_name]
      # patient.last_name = params[:last_name] if !params[:last_name].nil?
      # patient.patient_phone = params[:patient_phone] if params[:patient_phone]
      # patient.date_of_birth = params[:dob] if params[:dob]
      # patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
      # patient.mode_of_contact = params[:mode_of_contact] if params[:mode_of_contact]
      # patient.save
      # logger.debug("************THE converted the date format is : #{params[:date_of_appointment].to_date.strftime('%m/%d/%Y')}")
      appointment_date = params[:date_of_appointment].to_date.strftime('%m/%d/%Y') if params[:date_of_appointment]
      a.date_of_appointment = appointment_date if params[:date_of_appointment]
      a.service_provider_id = params[:sp_id] if params[:sp_id]
      a.reason_for_visit = params[:reason_for_visit] if params[:reason_for_visit]
      a.status = "Edit"
      a.notes = params[:note] if params[:note]
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
      notification_details = NotificationRule.selected_rules(params["task_id"] ,td_hrs)
      logger.debug("give_appointment_details_for_notification ********* #{notification_details}")
      if !notification_details.blank?
        logger.debug("YES YOU ARE ABOUT TO CREATE A NEW NOTIFICATION*******************************")
        n = Notification.new
        n.message = notification_details
        n.active = true
        # n.appointment_id = params["appointment_id"]
        n.task_id = params["task_id"]
        n.save
      end
      # NotificationRule.create(appointment_status: "New", time_difference: 48, greater: false, subject: "some subject for PCP", body: "Some message for PCP", client_application_id: c, user_type: "pcp" )
      # notification_response = Hash.new

      # notification = NotificationRule.where(:appointment_status => status, :appointment_time_passed => params["td_hrs"])
      # logger.debug("After NOTIFICATION RULE******************* #{notification.entries}")
      # subject = notification[0].subject
      # body = notification[0].body

      render :json => {status: :ok , notification_details: notification_details  }
    end


    def patient_appointments
      user = User.find_by(email:params[:email])
      if user.cc == true
        user_type = "cc"
      elsif user.pcp == true
        user_type = "pcp"
      end
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
        sp_id = a.service_provider_id
        notes = a.notes
        notification_data = [ ]
        logger.debug("the user type is : #{user_type}")
        if a.notifications.where(active: true)
          a.notifications.where(active: true).each do |n|
            logger.debug("the notification is #{n.inspect}**********")
            notification_id = n.id.to_s
            notification_body = n.message[user_type]["body"]
            notification_data.push(notification_id: notification_id, notification_body: notification_body )
          end
        end



        details_array = {appointment_id: appointment_id, patient_name: patient_name,
                         patient_dob: patient_dob, appointment_status: appointment_status,
                         referred_by: referred_by, rov: reason_for_visit, date_of_appointment: date_of_appointment,
                         notification_data: notification_data, sp_id: sp_id, note: notes }
        appointments_array.push(details_array)
        logger.debug("AFTER THE PUSH**********")
      end
      render :json => {status: :ok, patient_name: patient_name ,details_array: appointments_array }
    end

    def update_notifications

    end


    # def update_patient
    #   patient = Patient.find(params[:patient_id])
    #   patient.first_name = params[:first_name] if params[:first_name]
    #   patient.last_name = params[:last_name] if params[:last_name]
    #   patient.date_of_birth = params[:date_of_birth] if params[:date_of_birth]
    #   patient.patient_email = params[:patient_email] if params[:patient_email]
    #   patient.patient_phone = params[:patient_phone] if params[:patient_phone]
    #   patient.patient_coverage_id = params[:patient_coverage_id] if params[:patient_coverage_id]
    #   patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
    #   patient.mode_of_contact = params[:mode_of_contac] if params[:mode_of_contac]
    #   patient.patient_zipcode = params[:patient_zipcode] if params[:patient_zipcode]
    #   patient.save
    #
    #   render :json => {status: :ok, message: "Patient Details have been updated" }
    # end

    def crete_appointment_for_patient
      patient = Patient.find(params[:patient_id])

    end

    def set_password
      logger.debug("the parameters are : #{params.inspect}")
      raw_invitation_token = update_resource_params[:invitation_token]
      self.resource = accept_resource
      invitation_accepted = resource.errors.empty?

      yield resource if block_given?

      if invitation_accepted
        if Devise.allow_insecure_sign_in_after_accept
          logger.debug("in the first if******")
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message :notice, flash_message if is_flashing_format?
          # sign_in(resource_name, resource)
          # respond_with resource, :location => after_accept_path_for(resource)
          redirect_to "http://localhost:4200"
        else
          logger.debug("in the first else******")
          set_flash_message :notice, :updated_not_active if is_flashing_format?
          respond_with resource, :location => new_session_path(resource_name)
        end
      else
        logger.debug("in the second else******")
        resource.invitation_token = raw_invitation_token
        respond_with_navigational(resource){ render :edit }
      end
    end

    def get_faq

      if !params['email'].blank?
        user = User.find_by(email: params['email'])
        cc_id = user.client_application_id
      else
        cc_id = ClientApplication.where(master_application_status: true).first
      end

      @faqs = Faq.where(client_application_id: cc_id)

      if @faqs.empty?
        @faqs = ClientApplication.where(master_application_status: true).first.faq
      end

      render :json => { status: :ok, faqs: @faqs}
    end 

    def get_about_us

      if !params['email'].blank?
        user = User.find_by(email: params['email'])
        cc_id = user.client_application_id
      else
        cc_id = ClientApplication.where(master_application_status: true).first
      end

      @about_us = AboutU.where(client_application_id: cc_id)

      render :json => { status: :ok, about_us: @about_us}
    end 

    def get_terms

      if !params['email'].blank?
        user = User.find_by(email: params['email'])
        cc_id = user.client_application_id
      else
        cc_id = ClientApplication.where(master_application_status: true).first
      end

      @terms = TermsPrivacy.where(client_application_id: cc_id)
      if @terms.empty?
        @terms = ClientApplication.where(master_application_status: true).first.terms_privacy
      end
       render :json => { status: :ok, terms: @terms}

    end 

    def get_logo
      logger.debug("Params #{params}")
      user = User.find_by(email: params['email'])
      @logo = user.client_application.logo.url

      render :json => { status: :ok, logo: @logo}
      # render json: @logo, type: :jpeg, content_type: 'image/jpeg' 

    end 

    def admin_details 
      admin_details = ClientApplication.where(master_application_status: true).first.users.first
      render :json => { status: :ok, admin: admin_details}
    end 



    def user_profile
      user = User.find_by(email: params['email'])
      @user_profile = {}
        user.attributes.each do |k,v|
            case k.to_s
              when 'email'
                @user_profile[k.to_s] = v.to_s
              when 'active'
                @user_profile[k.to_s] = v.to_s
              when 'admin'
                @user_profile[k.to_s] = v.to_s
              when 'phone_number'
                @user_profile[k.to_s] = v.to_s
              when 'name'
                @user_profile[k.to_s] = v.to_s
              when 'otp_required_for_login'
                @user_profile[k.to_s] = v.to_s
            end 
        end 
      render :json => {status: :ok, profile: @user_profile}
    end 

    def edit_profile
      user = User.find_by(email: params['email'])
        user.email = params[:email] if params[:email]
        #user.active = params[:active] if params[:active]
        #user.admin = params[:admin] if params[:admin]
        user.phone_number = params[:phone_number] if params[:phone_number]
        user.name  = params[:name] if params[:name]
        user.otp_required_for_login = params[:otp_required_for_login] if params[:otp_required_for_login]
        user.save
        render :json => {status: :ok, message: "User Details have been updated" }
    end

    def app_version
      version =  ENV["APPLICATION_VERSION"]
      render :json => {status: :ok, version: version }
    end

    ##secondary Oauth Below

    def chcAuthentication
        user = User.find_by(email: params[:userEmail])
        user.tempToken = SecureRandom.hex
        user.save 
        #secCode = chcAuthentication.find_by(associatedURL: params[:originURL])
        #if secCode === params[:accessToken]
          render :json => { message: :ok, :redirect_url => "https://dev7.resourcestack.com/users/auth/google_oauth2"}
        #else 
          #render :json => {message: :unauthorized, :redirect_url => "originURL"}
        #end 
    end

    def forgot_password
      @user = User.find_by(email: params[:email])

      @user.send_reset_password_instructions

      render :json => {status: :ok, message: "Instructions have been sent to your email." }
    end

    ##oAuth Stuff

  end
end
