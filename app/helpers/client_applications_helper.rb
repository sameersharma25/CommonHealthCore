module ClientApplicationsHelper
  def catalog_table_content
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")

    # table_name = 'contact_management'
    table_name = ENV["CATALOG_TABLE_NAME"]
    params = {
        table_name: table_name,
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    result = dynamodb.scan(params)[:items] #.sort_by!{|k| k["created_at"]}.reverse!

  end
  
  def get_catalog(url)
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    table_name = ENV["CATALOG_TABLE_NAME"]

    parameters = {
        table_name: table_name,
        key: {
            # OrganizationName_Text: params["org_name"]
            url: url
        }
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    result = dynamodb.get_item(parameters)[:item]
  end


  def check_agreement_expiration(ca)
        @client_application = ca
        active_agreement = AgreementTemplate.where(agreement_type: @client_application.agreement_type, active: true).entries

        if active_agreement[0].client_agreement_valid_til == true
            #@client_application.client_agreement_expiration = active_agreement.agreement_expiration_date
            return active_agreement.agreement_expiration_date
        elsif active_agreement[0].client_agreement_valid_for == true
            if active_agreement[0].valid_for_interval == 'months'
              interval_month = 1
            elsif active_agreement[0].valid_for_interval == 'years'
              interval_month = 12
            else
              logger.debug("User did not pick. Need validations") 
            end 
            number_of_months =  (active_agreement[0].valid_for_integer.to_i * interval_month)
            expiration = Date.today + number_of_months.months
            logger.debug("expiration #{expiration}")
            #@client_application.client_agreement_expiration = expiration
            return expiration
        else
          logger.debug("Didn't pick an expiration date.")
        end 

  end

  def send_invite_to_user(email, client_application,name,role)
    logger.debug("********* In the send user invite method from the Client Application helper*********")
    @user = User.invite!(email: email, name: name,roles: [role])
    if @user.update(client_application_id: client_application , application_representative: true, admin: true)
      return true
    end
  end
end
