class SecurityKeysController < ApplicationController


	def index 
		@user = current_user

		@pii = PiiTable.all 
		@phi = PhiTable.all
		@sad = SadTable.all
		@patient = Patient.attribute_names
		@task = Task.attribute_names
	end 

	def create
		@pii = PiiTable.all 
		@phi = PhiTable.all
		@sad = SadTable.all

		case params['key_type'] 
			when 'pii'
				pii = PiiTable.new 
				pii.pii_key = params['key_name']
				pii.pii_value = params['key_value']
				pii.save
			when 'phi'
				phi = PhiTable.new
				phi.phi_key = params['key_name']
				phi.phi_value = params['key_value']
				phi.save
			when 'sad'
				sad = SadTable.new 
				sad.sad_key = params['key_name']
				sad.sad_value = params['key_value']
				sad.save
		end 

			
		#pass params key, values and what table. Create
	end  

	def update
		find_table = params['key_name'].split("_")[0]
		logger.debug("update #{find_table}")
		case find_table 
			when 'pii'
				@value_update = PiiTable.where(pii_key: params['key_name']).first
			when 'phi'
				@value_update = PhiTable.where(phi_key: params['key_name']).first
			when 'sad'
				@value_update = SadTable.where(sad_key: params['key_name']).first
		end 
		logger.debug("value to update #{@value_update}")

		#render partial
	end 

	def delete
		@pii = PiiTable.all 
		@phi = PhiTable.all
		@sad = SadTable.all
		#naming convention needs to be enforced
		find_table = params['key_name'].split("_")[0]
		logger.debug("training #{find_table}")
		case find_table 
			when 'pii'
				value_delete = PiiTable.where(pii_key: params['key_name']).first
			when 'phi'
				value_delete = PhiTable.where(phi_key: params['key_name']).first
			when 'sad'
				value_delete = SadTable.where(sad_key: params['key_name']).first
		end 

		value_delete.delete

	end 

end
