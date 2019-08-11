module PatientsHelper

	def security_keys_for_patients(values)
		patient_array = []
		security_keys = []

		#build an array with the value that the patient DOES have.
		values.attributes.each do |k,v|
			logger.debug("**KEY:::: #{k}, VALUE :::#{v}")
		  if v != '' && v != nil && k != 'client_application_id' && v != 'id'
		    patient_array.push(k)
		  end 
		end

		PiiTable.each do |key|
			if key['pii_value'] - patient_array == []
				security_keys.push(key['pii_key'])
			else 
			end 
		end 
		###
		PhiTable.each do |key|
			if key['phi_value'] - patient_array == []
				security_keys.push(key['phi_key'])
			else 
			end 
		end
		####
		SadTable.each do |key|
			if key['sad_value'] - patient_array == []
				security_keys.push(key['sad_key'])
			else 
			end 
		end
		return security_keys
	end #end def 


end


