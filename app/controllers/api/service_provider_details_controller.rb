module Api
  class ServiceProviderDetailsController < ActionController::Base

    load_and_authorize_resource class: :api

    def create_provider
      client_application = User.find_by(email: params[:email]).client_application_id.to_s
      logger.debug("client application: #{client_application}")
      sp = ServiceProviderDetail.new
      sp.client_application_id = client_application
      sp.service_provider_name = params[:service_provider_name]

      sp.service_provider_api = params[:service_provider_api] if params[:service_provider_api]
      sp.data_storage_type = params[:data_storage_type] if params[:data_storage_type]
      sp.provider_type = params[:provider_type] if params[:provider_type]
      sp.share = params[:share] if params[:share]
      sp.filtering_fields = params[:filtering_fields].to_unsafe_h
      logger.debug("SERVICE PROVIDER IS : #{sp.inspect}----------------------------")
      if sp.save
        logger.debug("SERVICE PROVIDER IS SAVED***************************")
        render :json=> {status: :ok, :message=> "Provide Details Created successfully"  }
      end


    end

    def edit_provider_details

      spd = ServiceProviderDetail.find(params[:spd_id])
      spd.service_provider_name = params[:service_provider_name]

      spd.service_provider_api = params[:service_provider_api] if params[:service_provider_api]
      spd.data_storage_type = params[:data_storage_type] if params[:data_storage_type]
      spd.provider_type = params[:provider_type] if params[:provider_type]
      spd.share = params[:share] if params[:share]
      spd.filtering_fields = params[:filtering_fields].to_unsafe_h

      if spd.save
        render :json=> {status: :ok, :message=> "Provide Details updated successfully"  }
      end

    end

    def filter_provider

      # service_provider_id = params[:provider_id]
      #
      # provider = ServiceProviderDetail.find(service_provider_id)
      #
      # logger.debug("the provider is: #{provider.inspect}")
      # database_storage = provider.data_storage_type
      # if database_storage == "External"
      #
      #
      # elsif database_storage == "Internal"
      #
      # end

      # https://aokx9crg6l.execute-api.us-west-2.amazonaws.com/prod/Hello?
      # input = {"input": "{\"treatment\": {type: \"Input\", value: [\"surgery\", \"cleaning\"]}}"}
      # a = ["surgery", "cleaning", "Pain"]

      a = 'Apple'
      b = 'Not Accepting'
      c = "99203"
      # input = {"Name": {type: "Input", value: a }, "Adult": {type: "Dropdown", value: b}}
      # input = {"Billing_Zip/Postal_Code": {type: "zipcode", value: c }}
      zip_adult = {"Billing_Zip/Postal_Code": {type: "zipcode", value: c },  "Adult": {type: "Dropdown", value: b} }
      name_adult = {"Name": {type: "Input", value: a }, "Adult": {type: "Dropdown", value: b}}

      input = params[:input]

      uri = URI("https://aokx9crg6l.execute-api.us-west-2.amazonaws.com/post_hash")
      header = {'Content-Type' => 'text/json'}

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, header)
      request.body = input.to_json

      logger.debug(" the request body is : #{request}")
      response = http.request(request)
      # puts "response #{response.body}"
      puts JSON.parse(response.body)
      render :json=> {status: :ok, :provider_data=> JSON.parse(response.body) }

    end

  end
end
