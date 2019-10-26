module Api
  class PatientsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: []
    load_and_authorize_resource class: :api



  def update_patient 
      patient = Patient.find(params[:patient_id])
      patient.first_name = params[:first_name].titleize if params[:first_name]
      patient.last_name = params[:last_name].titleize if params[:last_name]
      patient.date_of_birth = params[:date_of_birth] if params[:date_of_birth]
      patient.patient_email = params[:patient_email] if params[:patient_email]
      patient.patient_phone = params[:patient_phone] if params[:patient_phone]
      patient.patient_coverage_id = params[:patient_coverage_id] if params[:patient_coverage_id]
      patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
      patient.mode_of_contact = params[:mode_of_contact] if params[:mode_of_contact]

      if ZipCodes.identify(params[:patient_zipcode]).nil?
        logger.debug("Inside the zip validations*********************")
        render :json=> {message: "Please enter a valid zipcode"}
        return
      end
      patient.patient_zipcode = params[:patient_zipcode] if params[:patient_zipcode]
      patient.ethnicity = params[:ethnicity] if params[:ethnicity]
      patient.gender = params[:gender] if params[:gender]
      patient.patient_address = params[:patient_address] if params[:patient_address]

      patient.security_keys = helpers.security_keys_for_patients(patient)

      patient.primary_care_physician = params[:primary_care_physician] if params[:primary_care_physician]
      patient.emergency_contact_fName = params[:emergency_contact_fName] if params[:emergency_contact_fName]
      patient.emergency_contact_lName = params[:emergency_contact_lName] if params[:emergency_contact_lName]
      patient.emergency_contact_phone = params[:emergency_contact_phone] if params[:emergency_contact_phone]
      patient.emergency_contact_email = params[:emergency_contact_email] if params[:emergency_contact_email]
      patient.emergency_contact_relationship = params[:emergency_contact_relationship] if params[:emergency_contact_relationship]
      patient.population_group = params[:population_group] if params[:population_group]
      patient.service_group = params[:service_group] if params[:service_group]
      patient.client_consent = params[:client_consent] if params[:client_consent]

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
      patient.first_name = params[:first_name].titleize if params[:first_name]
      patient.last_name = params[:last_name].titleize if params[:last_name]
      patient.date_of_birth = params[:date_of_birth] if params[:date_of_birth]
      patient.patient_email = params[:patient_email] if params[:patient_email]
      patient.patient_phone = params[:patient_phone] if params[:patient_phone]
      patient.patient_coverage_id = params[:patient_coverage_id] if params[:patient_coverage_id]
      patient.healthcare_coverage = params[:healthcare_coverage] if params[:healthcare_coverage]
      patient.mode_of_contact = params[:mode_of_contact] if params[:mode_of_contact]

      if ZipCodes.identify(params[:patient_zipcode]).nil?
        logger.debug("Inside the zip validations*********************")
        render :json=> {message: "Please enter a valid zipcode"}
        return
      end
      patient.patient_zipcode = params[:patient_zipcode] if params[:patient_zipcode]
      patient.patient_address = params[:patient_address] if params[:patient_address]
      patient.ethnicity = params[:ethnicity] if params[:ethnicity]
      patient.gender = params[:gender] if params[:gender]
      patient.patient_status = "New"
      patient.security_keys = helpers.security_keys_for_patients(patient)

      patient.primary_care_physician = params[:primary_care_physician] if params[:primary_care_physician]
      patient.emergency_contact_fName = params[:emergency_contact_fName] if params[:emergency_contact_fName]
      patient.emergency_contact_lName = params[:emergency_contact_lName] if params[:emergency_contact_lName]
      patient.emergency_contact_phone = params[:emergency_contact_phone] if params[:emergency_contact_phone]
      patient.emergency_contact_email = params[:emergency_contact_email] if params[:emergency_contact_email]
      patient.emergency_contact_relationship = params[:emergency_contact_relationship] if params[:emergency_contact_relationship]
      patient.population_group = params[:population_group] if params[:population_group]
      patient.service_group = params[:service_group] if params[:service_group]
      patient.client_consent = params[:client_consent] if params[:client_consent]

      if patient.save
        render :json=> {status: :ok, message: "Patient Created Successfully", patient_id: patient.id.to_s}
      end
    end

    def create_note
      patient_id = params[:patient_id]
      note = Note.new
      note.note_text = params[:text]
      note.patient_id = patient_id
      if note.save
        render :json=> {status: :ok, message: "Note was created"}
      end

    end

    def patient_notes_list
      patient = Patient.find(params[:patient_id])
      notes_array = []
      notes = patient.notes
      notes.each do |note|
        text = note.note_text
        time = note.created_at.strftime("%m/%d/%Y %I:%M%p")
        note_hash = {text: text, time: time}
        notes_array.push(note_hash)
      end

      render :json => {status: :ok, notes_array: notes_array }

    end

    def med_patient
      med_arry = []
      patient = Patient.find(params[:patient_id])
      patient.referrals.each do |rfl|
        rfl.tasks.each do |tsk|
          if tsk.medical_case == true
            med_arry.push("true")
          end
        end
      end

      if med_arry.include?("true")
        response = true
      else
        response = false
      end

      render :json => {status: :ok, response: response}
    end

    def patient_details
      patient = Patient.find(params[:patient_id])
      dob = patient.date_of_birth
      age = dob.blank? ? "" :((Time.zone.now - dob.to_time) / 1.year.seconds).floor
      # if patient.patient_zipcode?
      #   patient_coords = Geocoder.search(patient.patient_zipcode)
      #   logger.debug("******the coordinates are : #{patient_coords.inspect}")
      #   patient_lat = patient_coords.first.coordinates[0]
      #   patient_lng = patient_coords.first.coordinates[1]
      # else
      #   patient_coords = Geocoder.search("99203")
      #   # logger.debug("******the coordinates are : #{patient_coords.inspect}")
      #   patient_lat = patient_coords.first.coordinates[0]
      #   patient_lng = patient_coords.first.coordinates[1]
      # end
      patients_details = {first_name: patient.first_name, last_name: patient.last_name,
                          ph_number: patient.patient_phone, date_of_birth: patient.date_of_birth,
                          patient_email: patient.patient_email, patient_zipcode: patient.patient_zipcode,
                          healthcare_coverage: patient.healthcare_coverage, patient_coverage_id: patient.patient_coverage_id,
                          mode_of_contact: patient.mode_of_contact, ethnicity: patient.ethnicity, gender: patient.gender,
                          patient_address: patient.patient_address, age: age, primary_care_physician: patient.primary_care_physician,
                          emergency_contact_fName: patient.emergency_contact_fName, emergency_contact_lName: patient.emergency_contact_lName,
                          emergency_contact_phone: patient.emergency_contact_phone, emergency_contact_email: patient.emergency_contact_email,
                          emergency_contact_relationship: patient.emergency_contact_relationship, population_group: patient.population_group,
                          service_group: patient.service_group, client_consent: patient.client_consent}

      render :json => {status: :ok, patients_details: patients_details }
    end



    def patients_list
      user = User.find_by(email: params[:email])
      c = user.client_application_id
      if params[:search] and !params[:search].blank?
        # patients = Patient.where("last_name LIKE ?", "%#{params[:search]}%")
        # patients = Patient.where(client_application_id: c,:last_name => Regexp.new(params[:search], true),:first_name_name => Regexp.new(params[:search], true) ).order(first_name: :asc)
        patients = Patient.where(client_application_id: c).or({:last_name => Regexp.new(params[:search], true)},{:first_name => Regexp.new(params[:search], true)}).order(first_name: :asc)
        # patients = Patient.where(client_application_id: c).or({:first_name => Regexp.new(params[:search], true)},{:last_name => Regexp.new(params[:search], true)}).order(first_name: :asc)
      else
        patients = Patient.where(client_application_id: c).order(last_name: :asc)
      end

      patients_details = Array.new
      # active_notification = false
      active_notification_array = []
      patients.each do |p|
        patient_id = p.id.to_s
        first_name = p.first_name
        last_name = p.last_name
        ph_number = p.patient_phone
        p_status = p.patient_status
        p_email = p.patient_email
        dob = p.date_of_birth
        p_age = dob.blank? ? "" : ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
        active_notification = false
        p.appointments.each do |a|
          a.notifications.each do |n|
            if n.active == true
              active_notification = true
            end
          end
        end
        active_notification_array.push(active_notification)
        patient_detail = {patient_id: patient_id, first_name: first_name, last_name: last_name,
                          ph_number: ph_number,email: p_email,p_age: p_age, active_notification: active_notification, p_status: p_status }
        patients_details.push(patient_detail)
      end
      active_notification_array_count = active_notification_array.count(true)
      render :json => {status: :ok, patients_details: patients_details , active_notifications_count: active_notification_array_count}
    end

  end
end
