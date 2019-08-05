module Api
  class ServiceProviderDetailsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:create_catalog_entry,:update_catalog_entry,:scrappy_doo_response, :authenticate_user_email, :site_update,
                                                          :get_catalogue_site_by_id,:catalogue_site_list,:get_catalogue_program_by_id,
                                                          :site_program_list,:program_update,:contact_management_details_for_plugin]
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

      logger.debug("the parameters are: #{params.inspect}")
      sr = ScrapingRule.find(params[:rule_id])
      rules_to_change = params[:ruleToChange]
      rules_to_change.each do |r_change|
        if r_change == "organizationName"
          sr.organizationName_changeeee = true
        elsif r_change == "organizationDescription"
          sr.organizationDescription_changeeee = true
        end
      end
      sr.save
      #{"ruleToChange"=>["OrganizationName", "OrganizationDescription"], "rule_id"=>" 5c7418b158f01a070996c531", "service_provider_detail"=>{}}

    end

    def contact_management_details_for_plugin
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

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
      table_name = 'contact_management'

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
      }

      result = dynamodb.get_item(parameters)[:item]["orgSites"].select{|item| item["selectSiteID"] == params["selectSiteID"]}

      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}


      # logger.debug("the Result of the get entry is : #{result}")
      render :json => {status: :ok, result: result }

    end

    def site_update

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

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

      result = dynamodb.get_item(parameters)[:item]["orgSites"]
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}
      site_id = params[:selectSiteID]

      result.delete_if {|h| h["selectSiteID"] == site_id }
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
          update_expression: "set orgSites = :r ",
          expression_attribute_values: {
          ":r" => result
      },
          return_values: "UPDATED_NEW"
      }

      begin
        dynamodb1.update_item(parameters)
        mandatory_parameters_check_after_update(params["url"], "Updating")
        render :json => {status: :ok, message: "Site Updated" }

      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end

    end

    def site_program_list
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

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


      site_result = dynamodb.get_item(parameters)[:item]["orgSites"].collect{|item| [item["selectSiteID"],item["locationName"]]}

      program_result = dynamodb.get_item(parameters)[:item]["programs"].collect{|item| [item["selectprogramID"],item["programName"]]}

      logger.debug("the Result of the get entry is : #{program_result}")
      render :json => {status: :ok, site: site_result, program: program_result }
    end


    def get_catalogue_program_by_id

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

      parameters = {
          table_name: table_name,
          key: {
              # OrganizationName_Text: params["org_name"]
              # url: params["org_url"]
              url: params["url"]
          }
      }

      result = dynamodb.get_item(parameters)[:item]["programs"].select{|item| item["selectprogramID"] == params["selectprogramID"]}
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}


      # logger.debug("the Result of the get entry is : #{result}")
      render :json => {status: :ok, result: result.first }

    end

    def program_update

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

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

      result = dynamodb.get_item(parameters)[:item]["programs"]
      # result = dynamodb.get_item(parameters)[:item]["OrgSites"].collect{|item| item["ID"]}
      program_id = params[:selectprogramID]

      result.delete_if {|h| h["selectprogramID"] == program_id }
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
          update_expression: "set programs = :r ",
          expression_attribute_values: {
              ":r" => result
          },
          return_values: "UPDATED_NEW"
      }

      begin
        dynamodb1.update_item(parameters)
        render :json => {status: :ok, message: "Program Updated" }

      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end


    end

    def create_catalog_entry

      item = params[:catalog_data].to_unsafe_h
      user = User.find_by(email: params[:email])
      client_application_id = user.client_application_id.to_s
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'
      # domain_name = Addressable::URI.parse(params[:catalog_data]["url"]).host
      # item["url"] = "https://"+domain_name+"/"
      url_split = params[:catalog_data]["url"].split("/")
      item["url"] = url_split[0]+"//"+url_split[2]+"/"
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

      begin
        dynamodb.put_item(params)
        render :json => { status: :ok, message: "Entry created successfully"  }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end

    end

    def update_catalog_entry
      geoScope = params[:geoScope].to_unsafe_h if params[:geoScope]
      organizationName = params[:organizationName].to_unsafe_h if params[:organizationName]

      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'

      if geoScope && organizationName
        parameters = {
            table_name: table_name,
            key: {
                url: params["url"]
            },
            update_expression: "set geoScope = :g , organizationName = :o ",
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
            update_expression: "set geoScope = :g ",
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
            update_expression: "set organizationName = :o ",
            expression_attribute_values: {
                ":o" => organizationName
            },
            return_values: "UPDATED_NEW"
        }

      end

      begin
        dynamodb.update_item(parameters)
        mandatory_parameters_check_after_update(params["url"], "Updating")
        render :json => {status: :ok, message: "Catalog Updated" }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end


    end

    def mandatory_parameters_check_after_update(item, event)
      result = mandatory_parameters_check(item, event)
      dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
      table_name = 'contact_management'
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
        table_name = 'contact_management'

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

      scope = item["geoScope"]["geoScope"]
      if scope == "Virtual"
        home_page_url = item["organizationName"]["homepageURL"]
        check_mandatory_field(home_page_url,item)

      elsif scope == "County"
        county = item["geoScope"]["County"]
        check_mandatory_field(county,item)

      elsif scope == "Region"
        region = item["geoScope"]["region"]
        # logger.debug("CHECKING THE REGION***************** #{region}")
        check_mandatory_field(region,item)

      elsif scope == "State"
        state = item["geoScope"]["State"]
        check_mandatory_field(state,item)

      elsif scope == "National"
        national = item["geoScope"]["country"]
        check_mandatory_field(national,item)

      elsif scope == "On Site"
        sites = item["orgSites"]
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








  end
end
