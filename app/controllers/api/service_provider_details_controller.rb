module Api
  class ServiceProviderDetailsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:create_catalog_entry,:update_catalog_entry,:scrappy_doo_response, :authenticate_user_email, :site_update,
                                                          :get_catalogue_site_by_id,:catalogue_site_list,:get_catalogue_program_by_id,
                                                          :site_program_list,:program_update,:contact_management_details_for_plugin, :update_entire_catalog]
    load_and_authorize_resource class: :api, except: [:create_catalog_entry,:update_catalog_entry,:scrappy_doo_response, :authenticate_user_email,:site_update,
                                                      :get_catalogue_site_by_id,:catalogue_site_list,:get_catalogue_program_by_id,
                                                      :site_program_list,:program_update,:contact_management_details_for_plugin]

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
      sp.provider_data_file = params[:provider_data_file]
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

    def scrappy_doo_response

      change_array = []
      full_change_array = []
      # sr = ScrapingRule.new
      sr = ScrapingRule.find(params[:ruleToChange][:rule_id])
      sr.organizationName_changeeee = false
      sr.organizationDescription_changeeee = false
      sr.url_changeeee = false
      #sr.url = params[:ruleToChange][:url]
      params[:ruleToChange][:ruleToChange].each do |p|
        # logger.debug("the P is #{p}")
        change_array.push(p.keys)
        full_change_array.push(p.to_unsafe_h)
      end
      # logger.debug("Type od chcanges : #{change_array}")
      # sr.changed_fields = change_array.flatten
      # sr.changed_fields = params[:ruleToChange][:ruleToChange]
      sr.changed_fields = full_change_array
      # logger.debug("the scrappy params areeee: #{sr.inspect}")
      change_array.flatten.each do |c|
        if c == "OrganizationName"
          sr.organizationName_changeeee = true
        elsif c == "OrganizationDescription"
          sr.organizationDescription_changeeee = true
        elsif c == "url"
          sr.url_changeeee = true
        end
      end

      sr.save

      # logger.debug("the parameters are: #{params.inspect}")
      # sr = ScrapingRule.find(params[:rule_id])
      # rules_to_change = params[:ruleToChange]
      # rules_to_change.each do |r_change|
      #   if r_change == "organizationName"
      #     sr.organizationName_changeeee = true
      #   elsif r_change == "organizationDescription"
      #     sr.organizationDescription_changeeee = true
      #   end
      # end
      # sr.save
      #{"ruleToChange"=>["OrganizationName", "OrganizationDescription"], "rule_id"=>" 5c7418b158f01a070996c531", "service_provider_detail"=>{}}

    end

    def contact_management_details_for_plugin
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              url: params["url"]
          }
          # projection_expression: "url",
          # filter_expression: "url = test1.com"
      }

      result = dynamodb.get_item(parameters)[:item]
      if result.nil?
        # result = {status: :ok, messagge: "Catalogue does not exists."}
        render :json => {status: :ok, message: "Catalogue does not exists."}
      else
        # logger.debug("the Result of the get entry is : #{result}")
        render :json => {status: :ok, message: "Catalogue does exists.", result: result }
      end


    end


    def get_catalogue_site_by_id

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
      }

      result = dynamodb.get_item(parameters)[:item]["OrgSites"].select{|item| item["SelectSiteID"] == params["SelectSiteID"]}

      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}


      # logger.debug("the Result of the get entry is : #{result}")
      render :json => {status: :ok, result: result }

    end

    def site_update

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
          # projection_expression: "url",
          # filter_expression: "url = test1.com"
      }

      result = dynamodb.get_item(parameters)[:item]["OrgSites"]
      result = result.nil? ? [] : result
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}
      site_id = params[:SelectSiteID]

      if result.first.nil?
        result.pop
      end
      result.delete_if {|h| h["SelectSiteID"] == site_id }

      new_hash = params[:newHash].first.to_unsafe_h

      logger.debug("the new hash IS : #{new_hash}")

      result.push(new_hash)

      logger.debug("the new result is : #{result}")

      dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          },
          update_expression: "set OrgSites = :r ",
          expression_attribute_values: {
          ":r" => result
      },
          return_values: "UPDATED_NEW"
      }

      begin
        dynamodb1.update_item(parameters)

        input = {"catalog": {url: params["url"], sites: result} }
        uri = URI("http://pg.commonhealthcore.org/update_sites")
        # uri = URI("http://localhost:3000/update_sites")
        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        # http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, header)
        request.body = input.to_json

        logger.debug(" the request body is : #{request}")
        response = http.request(request)
        puts "response {response.body} "
        # puts JSON.parse(response.body)

        mandatory_parameters_check_after_update(params["url"], "Updating")
        render :json => {status: :ok, message: "Site Updated" }

      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end

    end

    def site_program_list
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              url: params["url"]
              # url: "test1.com"
          }
          # projection_expression: "url",
          # filter_expression: "url = test1.com"
      }


      site_result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| [item["SelectSiteID"],item["LocationName"]]}

      program_result = dynamodb.get_item(parameters)[:item]["Programs"].collect{|item| [item["SelectprogramID"],item["ProgramName"]]}

      logger.debug("the Result of the get entry is : #{program_result}")
      render :json => {status: :ok, site: site_result, program: program_result }
    end


    def get_catalogue_program_by_id

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
      }

      result = dynamodb.get_item(parameters)[:item]["Programs"].select{|item| item["SelectprogramID"] == params["SelectprogramID"]}
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}


      # logger.debug("the Result of the get entry is : #{result}")
      render :json => {status: :ok, result: result.first }

    end

    def program_update

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
          # projection_expression: "url",
          # filter_expression: "url = test1.com"
      }
      result1 = dynamodb.get_item(parameters)[:item]
      result = result1["Programs"]
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}
      program_id = params[:SelectprogramID]

      result.delete_if {|h| h["SelectprogramID"] == program_id }
      new_hash = params[:newHash].first.to_unsafe_h

      logger.debug("the new hash IS : #{new_hash}")

      result.push(new_hash)

      logger.debug("the new result is : #{result}")

      dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          },
          update_expression: "set Programs = :r ",
          expression_attribute_values: {
              ":r" => result
          },
          return_values: "UPDATED_NEW"
      }

      begin
        dynamodb1.update_item(parameters)
        input = {"catalog": {url: params["url"], programs: result, dyna_entry: result1} }
        uri = URI("http://pg.commonhealthcore.org/update_programs")
        # uri = URI("http://localhost:3000/update_programs")
        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        # http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, header)
        request.body = input.to_json

        logger.debug(" the request body is : #{request}")
        response = http.request(request)
        puts "response {response.body} "
        # puts JSON.parse(response.body)


        render :json => {status: :ok, message: "Program Updated" }

      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end


    end

    def create_catalog_entry
      begin
        item = params[:catalog_data].to_unsafe_h
        item["GeoScope"]["Country"] = "US"
        body_json = JSON.parse(request.body.read)
        body_json["catalog_data"]["GeoScope"]["Country"] = "US"
        params_validation = CatalogManagement::CatalogEntryWithEmailContract.new.call(body_json)
        unless params_validation.success?
          InvalidCatalogEntry.new(email: params[:email], url: item[:url] ,catalog_hash: item ,error_hash: params_validation.errors.to_hash).save
          logger.debug("catalog errors: #{params_validation.errors.to_hash}")
          return render :json => { status: "error", message: params_validation.errors.to_hash  }
        end
        item = CatalogManagement::CatalogEntityValidator.new(item).to_h.deep_stringify_keys
        user = User.find_by(email: params[:email])
        client_application_id = user.client_application_id.to_s
        dynamodb = if Rails.env.test?  #TODO: For now checking in controller need to move initializers and pick based on env
                     Aws::DynamoDB::Client.new(stub_responses: true)
                   else
                     Aws::DynamoDB::Client.new(region: "us-west-2")
                   end
        table_name = ENV["CATALOG_TABLE_NAME"]
        # domain_name = Addressable::URI.parse(params[:catalog_data]["url"]).host
        # item["url"] = "https://"+domain_name+"/"
        #url_split = params[:catalog_data]["url"].split("/")
        #item["url"] = url_split[0]+"//"+url_split[2]+"/"
        item["customer_id"] = client_application_id
        item["status"] = "New"
        created_at = DateTime.now.strftime("%F %T")
        item["created_at"] = created_at
        item["catalog_id"] = SecureRandom.hex(13)
        item["rejectReason"] = "N/A"

        item1=  mandatory_parameters_check(item, "Creating")
        logger.debug(")))))))))))))))))))))))))))))))))))))))))))the item is : #{item1}")

        params = {
            table_name: table_name,
            item: item1
        }

        dynamodb.put_item(params)


        create_pg_entry(item1)

        render :json => { status: :ok, message: "Entry created successfully"  }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        InvalidCatalogEntry.new(email: params[:email], url: item[:url], catalog_hash: item ,error_hash: error).save
        render :json => {message: error  }
      end

    end

    def create_pg_entry(item)

      input = {"catalog": item }
      uri = URI("http://pg.commonhealthcore.org/create_new_entry")
      # uri = URI("http://localhost:3000/create_new_entry")
      header = {'Content-Type' => 'application/json'}

      http = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, header)
      request.body = input.to_json

      logger.debug(" the request body is : #{request}")
      response = http.request(request)
      puts "response {response.body} "
      # puts JSON.parse(response.body)
    end

    def update_catalog_entry
      geoScope = params[:GeoScope].to_unsafe_h if params[:GeoScope]
      organizationName = params[:OrganizationName].to_unsafe_h if params[:OrganizationName]

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]

      if geoScope && organizationName
        parameters = {
            table_name: table_name,
            key: {
                url: params["url"]
            },
            update_expression: "set GeoScope = :g , OrganizationName = :o ",
            expression_attribute_values: {
                ":g" => geoScope,
                ":o" => organizationName
            },
            return_values: "UPDATED_NEW"
        }
      elsif geoScope && !organizationName
        parameters = {
            table_name: table_name,
            key: {
                url: params["url"]
            },
            update_expression: "set GeoScope = :g ",
            expression_attribute_values: {
                ":g" => geoScope,
            },
            return_values: "UPDATED_NEW"
        }
      elsif organizationName && !geoScope
        parameters = {
            table_name: table_name,
            key: {
                url: params["url"]
            },
            update_expression: "set OrganizationName = :o ",
            expression_attribute_values: {
                ":o" => organizationName
            },
            return_values: "UPDATED_NEW"
        }

      end

      begin
        dynamodb.update_item(parameters)
        # logger.debug("**********the parameters are #{params.to_unsafe_h}")
        create_pg_entry(params.to_unsafe_h)
        mandatory_parameters_check_after_update(params["url"], "Updating")
        render :json => {status: :ok, message: "Catalog Updated" }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end


    end

    def mandatory_parameters_check_after_update(item, event)
      result = mandatory_parameters_check(item, event)
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]
      parameters = {
          table_name: table_name,
          key: {
              url: params["url"]
          },
          update_expression: "set missing_mandatory_fields = :o ",
          expression_attribute_values: {
              ":o" => result["missing_mandatory_fields"]
          },
          return_values: "UPDATED_NEW"
      }
      begin
        dynamodb.update_item(parameters)
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end
    end

    def mandatory_parameters_check(item, event)

      if event == "Updating"
        dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2") 
        table_name = ENV["CATALOG_TABLE_NAME"]

        parameters = {
            table_name: table_name,
            key: {
                # OrganizationName_Text: params["org_name"]
                # url: params["org_url"]
                url: item
            }
        }

        item = dynamodb.get_item(parameters)[:item]
      end

      scope = item["GeoScope"]["Scope"]
      if scope == "Virtual"
        home_page_url = item["OrganizationName"]["HomepageURL"]
        check_mandatory_field(home_page_url,item)

      elsif scope == "County"
        county = item["GeoScope"]["County"]
        check_mandatory_field(county,item)

      elsif scope == "Region"
        region = item["GeoScope"]["Region"]
        # logger.debug("CHECKING THE REGION***************** #{region}")
        check_mandatory_field(region,item)

      elsif scope == "State"
        state = item["GeoScope"]["State"]
        check_mandatory_field(state,item)

      elsif scope == "National"
        national = item["GeoScope"]["Country"]
        check_mandatory_field(national,item)

      elsif scope == "On Site"
        sites = item["OrgSites"]
        address_text_array = []
        sites.each do |site|
          site_text = site["addrOne_Text"]
          if !site_text.nil?
            address_text_array.push(site_text)
          end
        end
        # logger.debug("CHECKING THE site address ***************** #{address_text_array}")

        address_ok = address_text_array.empty? ? nil : "true"

        check_mandatory_field(address_ok,item)
      elsif scope.nil?
        check_mandatory_field(nil,item)
      end

      # logger.debug("------------------------In the mandatory_parameters_check #{item} ")
      item
    end

    def check_mandatory_field(field,item)
      # logger.debug("**************************in teh check_mandatory_field")
      if !field.nil? || !field.blank?
        item["missing_mandatory_fields"] = "0"
      else
        item["missing_mandatory_fields"] = "1"
      end
      # logger.debug("**************************in teh check_mandatory_field #{item}")
      item
    end


    # def catalogue_program_list
    #
    #   dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    #   table_name = 'contact_management'
    #
    #   parameters = {
    #       table_name: table_name,
    #       key: {
    #           # OrganizationName_Text: params["org_name"]
    #           url: params["url"]
    #           # url: "test1.com"
    #       }
    #       # projection_expression: "url",
    #       # filter_expression: "url = test1.com"
    #   }
    #
    #
    #   result = dynamodb.get_item(parameters)[:item]["programs"].collect{|item| item["selectprogramID"]}
    #
    #
    #   # logger.debug("the Result of the get entry is : #{result}")
    #   render :json => {status: :ok, result: result }
    # end



    def authenticate_user_email
      user = User.find_by(email: params[:email])
      authentication_token = user.authentication_token
      ability_array = []
      user_roles = user.roles
      user_roles.each do |ur|
        role = Role.find(ur)
        abilities = role.role_abilities.first["action"]
        abilities.each do |a|
          ability_array.push(a)
        end
      end

      logger.debug("the email being authenticated is : #{user.inspect}")
      logger.debug("******************the ability array is : #{ability_array}")

      if user
        render :json=> {status: :ok, :message=> "Valid User", "user-token" => authentication_token, "abilities" => ability_array  }
      else
        render :json=> {status: :unauthorized, :message=> "Invalid User" }
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


    ###
    def update_entire_catalog

      item = params[:catalog_data].to_unsafe_h
      #user = User.find_by(email: params[:email])
      #client_application_id = user.client_application_id.to_s
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = ENV["CATALOG_TABLE_NAME"]
      # domain_name = Addressable::URI.parse(params[:catalog_data]["url"]).host
      # item["url"] = "https://"+domain_name+"/"
      #url_split = params[:catalog_data]["url"].split("/")
      #item["url"] = url_split[0]+"//"+url_split[2]+"/"
      #item["customer_id"] = client_application_id
      #item["status"] = "New"
      #created_at = DateTime.now.strftime("%F %T")
      #item["created_at"] = created_at
      # item["catalog_id"] = SecureRandom.hex(13)
      # item["rejectReason"] = "N/A"

      item["Programs"].each do |p|
        # logger.debug("-----------Program sites are #{p["ProgramSites"]}")
        if p["ProgramSites"]
          ps = p["ProgramSites"].first
          # ps.split(',')
          # logger.debug("-----------SSplit program is Program sites are #{ps.split(',')}")
          p["ProgramSites"] = ps.split(',')
          # logger.debug("-----------At the end Program sites are #{p["ProgramSites"]}")
        end

      end
      item1=  mandatory_parameters_check(item, "Creating")
      logger.debug(")))))))))))))))))))))))))))))))))))))))))))the item is : #{item1}")

      params = {
          table_name: table_name,
          item: item1
      }

      begin
        dynamodb.put_item(params)
        render :json => { status: :ok, message: "Entry created successfully"  }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end

    end
    ###








  end
end
