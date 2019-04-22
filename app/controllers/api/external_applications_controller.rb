module Api
  class ExternalApplicationsController < ActionController::Base


    def send_patient
      # task_id = params[:task_id]
      # task = Task.find(task_id)

      external_application_id = params[:external_application_id]

      external_api = ExternalApiSetup.where(client_application_id: external_application_id, api_for: "send_patient").first
      first_name = "Test"
      patient_address = "Planet Earth"
      logger.debug("the MAPPED PARAMETERS ARE: #{external_api.mapped_parameters.entries}")
      external_api.mapped_parameters.each do|mp|
        mp.external_parameter = mp.chc_parameter
        logger.debug("the parameter value is : #{mp.external_parameter}, -----#{first_name}")
      end





    end

    def client_list
      all_client = ClientApplication.all
      all_client_array = []
      all_client.each do |ac|
        name = ac.name
        id =  ac.id.to_s
        client_hash = {name: name, id: id}
        all_client_array.push(client_hash)
      end

      # logger.debug("the list of the client is: #{all_client_array}")
      render :json=> {status: :ok, client_list: all_client_array.sort_by{|h| h[:name].downcase} }

    end


  end
end