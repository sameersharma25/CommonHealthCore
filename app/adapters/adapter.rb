module Adapter
  class DentistlinkWrapper
    attr_accessor :patient
    def initialize(patient)
      Rails.logger.debug("INSIDE APAPTER initialize")
      #obtain the token
      input = 
      {
        "EmailId": "sameer.sharma@resourcestack.com",
        "Password": "ZAQ!2wsx"
      }
      #input = {"user_hash": user_hash}
      url = URI("https://webapi.dentistlink.org/api/tenantauth/getlogintoken")
      header = {'Content-Type' => 'application/json'}
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url.path, header)
      request.body = input.to_json
      response = http.request(request)
      Rails.logger.debug("RESPONSE #{response.body}")
      result = JSON.parse(response.body)
      token_data = result["Data"]["TokenData"]["Token"]
      Rails.logger.debug("TOKEN DATA #{token_data.inspect}")
      @token = "Bearer" + " " + token_data
      Rails.logger.debug("TOKEN #{@token.inspect}")

      
    end

    def reason_for_visit(patient, task)

      @reason_for_visit = "Cleaning/Checkup"

    end

    def send_patient_sf(patient, task)
      reason_for_visit = reason_for_visit(patient, task)
      token = @token
      Rails.logger.debug("SEND PATIENT TOKEN #{token.inspect}")
      #Authorization = @token
      puts "SEND PATIENT SF"
      patient = patient
      Rails.logger.debug("SEND PATIENT PATIENT #{patient.inspect}")
      #url = URI("https://webto.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8")
      url = URI("https://webapi.dentistlink.org/api/referral/submitreferralform")
      header = {'Content-Type' => 'application/json', 'Authorization' => token}
      Rails.logger.debug("HEADER IN SEND PATIENT #{header.inspect}")
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            dob = patient.date_of_birth.split('/').rotate(-1).join('-')
            request = Net::HTTP::Post.new(url)
            input = 
            {
                "Referring_Provider_Name": "CHC",
                "Patient_FirstName": patient.first_name,
                "Patient_LastName": patient.last_name,
                "Patient_DOB": patient.date_of_birth.to_date.strftime('%Y-%m-%d'),
                "Reason_For_Visit": reason_for_visit,
                "Zip": patient.patient_zipcode,
                "Preferred_Contact_Method": "Text",
                "Mobile": patient.patient_phone,
                "Pregnant_Diabetic": "Pregnant",
                "Coverage_Type": "Other",
                "Care_Coordination_Notes": "Testing from CHC",
                "Other_Coverage_Type": "Other coverage type",
                "Care": "No",
                "Patient_Source__c": "CHC Referral",
                "Referral_Source": "CHC-Test"
            }
            request = Net::HTTP::Post.new(url.path, header)
            request.body = input.to_json
            Rails.logger.debug("SEND PATIENT REQUEST #{request.body.inspect}")
            response = http.request(request)
            puts response.read_body
            res = JSON.parse(response.read_body)
            
    end
  end
end
