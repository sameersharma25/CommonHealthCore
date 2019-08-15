module PatientsHelper

	def security_keys_for_patients(values)
		patient_array = []
		security_keys = []


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
				#[first_name,dob,task_description,task_status]  - [patient details and task details ]
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
		logger.debug("THE KEYS BEING ADDED ARE::: #{security_keys}")
		return security_keys
	end #end def 


end


