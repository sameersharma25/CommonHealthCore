module PatientsHelper

	def security_keys_for_patients(values)
		patient_array = []
		security_keys = []

		values.each do |k,v|
		  if v != '' && v != nil
		    patient_array.push(v)
		  end 
		end

		PiiTable.each do |k,v|
		  p 'security key set', v
		  p 'patient set', patient_array 
		  if (v - patient_array) == []
		  	patient_array.push(k)
		  else 
		    p patient_array, '!=', v
		  end 
		  p '*** BREAK ***'
		end 
		##
		PhiTable.each do |k,v|
		  p 'security key set', v
		  p 'patient set', patient_array 
		  if (v - patient_array) == []
		  	patient_array.push(k)
		  else 
		    p patient_array, '!=', v
		  end 
		  p '*** BREAK ***'
		end 
		##
		SadTable.each do |k,v|
		  p 'security key set', v
		  p 'patient set', patient_array 
		  if (v - patient_array) == []
		  	patient_array.push(k)
		  else 
		    p patient_array, '!=', v
		  end 
		  p '*** BREAK ***'
		end 
		return security_keys
	end #end def 


end

