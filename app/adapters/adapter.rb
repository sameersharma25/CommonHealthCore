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

    def send_patient_sf(patient)
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

            request = Net::HTTP::Post.new(url)
            input = 
            {
                "Referring_Provider_Name": "CHC",
                "Patient_FirstName": patient.first_name,
                "Patient_LastName": patient.last_name,
                "Patient_DOB": patient.date_of_birth,
                "Reason_For_Visit": "Cleaning/Checkup",
                "Zip": "42351",
                "Preferred_Contact_Method": "Text",
                "Mobile": "9876543210",
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
           # request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
           #  request["cache-control"] = 'no-cache'
           #  request["postman-token"] = '5127317f-ae78-f5f0-5a15-2e1814eb0e2c'
           #  request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"recordType\"\r\n\r\n01241000000vbjk\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000bdkqr\"\r\n\r\nCHC-Test\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"oid\"\r\n\r\n00D41000001itfQ\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"retURL\"\r\n\r\nhttp://demo.dentislink.org\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"first_name\"\r\n\r\n#{patient.first_name}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"last_name\"\r\n\r\n#{patient.last_name}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"zip\"\r\n\r\n#{patient.patient_zipcode}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000QTuKi\"\r\n\r\n#{patient.date_of_birth}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000QTuYV\"\r\n\r\n#{patient.mode_of_contact}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"mobile\"\r\n\r\n#{patient.patient_phone}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"email\"\r\n\r\n#{patient.patient_email}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000QUJpC\"\r\n\r\n#{patient.healthcare_coverage}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000QTuLl\"\r\n\r\n#{patient.patient_coverage_id}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"00N4100000enVX0\"\r\n\r\n#{patient.notes.first.note_text if patient.notes.first}\r\n
           #                  ------WebKitFormBoundary7MA4YWxkTrZu0gW--"

            response = http.request(request)
            puts response.read_body
            return
    end
  end
end
