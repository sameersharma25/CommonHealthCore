module ClientApplicationsHelper
  def catalog_table_content
    results = []
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")

    # table_name = 'contact_management'
    table_name = ENV["CATALOG_TABLE_NAME"]
    params = {
        table_name: table_name,
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    # result = dynamodb.scan(params)[:items] #.sort_by!{|k| k["created_at"]}.reverse!
    result = dynamodb.scan(params) #.sort_by!{|k| k["created_at"]}.reverse!

    loop do
      # logger.debug("*************************the count of the iteration is : #{result.items.count}, and the result is : #{result}")
      results << result.items
      break unless (lek = result.last_evaluated_key)
      result = dynamodb.scan params.merge(exclusive_start_key: lek)
    end

    results.flatten
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

  def set_default_description_display
    if @OrgDescription.present? && @orgDetails["OrganizationDescriptionDisplay"].blank?
      @default_description = true
      @orgDetails["OrganizationDescriptionDisplay"] = @OrgDescription.map{|p| p["Text"]}.compact.reject(&:empty?).join(' ')
    end

    @program.each do |program|
      if program["ProgramDescription"].present? && program["ProgramDescriptionDisplay"].blank?
        program["ProgramDescriptionDisplay"] = program["ProgramDescription"].map{|p| p["Text"]}.compact.reject(&:empty?).join(' ')
      end

      if program["ServiceAreaDescription"].present? && program["ServiceAreaDescriptionDisplay"].blank?
        program["ServiceAreaDescriptionDisplay"] = program["ServiceAreaDescription"].map{|p| p["Text"]}.compact.reject(&:empty?).join(' ')
      end

      if program["PopulationDescription"].present? && program["PopulationDescriptionDisplay"].blank?
        program["PopulationDescriptionDisplay"] = program["PopulationDescription"].map{|p| p["Text"]}.compact.reject(&:empty?).join(' ')
      end

    end
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
    logger.debug("********* In the send user invite method from the Client Application helper after invite #{@user.inspect}*********")
    if @user.update(client_application_id: client_application , application_representative: true, admin: true)
      return true
    end
  end

  def send_referral_common(task_id,referred_application_id, user_id)

    referred_by_id = Task.find(task_id).referral.client_application.id.to_s
    ledger_master = LedgerMaster.where(task_id: task_id).first
    ledger_master_id = ledger_master.id.to_s
    referred_applicaiton = ClientApplication.find(referred_application_id)
    client_user = referred_applicaiton.users.first
    client_user_email = client_user.email

    exixting_status= ledger_master.ledger_statuses.where(referred_application_id: referred_application_id )
    logger.debug("send_referral_common--------the existing status value is : #{exixting_status.entries}")
    if !exixting_status.empty?
      logger.debug("send_referral_common--------the IF BLOCK OF EXISTING***************")
      req_status = "ok"
      message = "Referral Request already exists"
    else
      logger.debug("send_referral_common--------the ELSE BLOCK OF EXISTING***************")

      logger.debug("send_referral_common--------the user is #{client_user}, ******** USER EMAIL IS : #{client_user_email}")
      led_stat = LedgerStatus.new
      led_stat.referred_application_id = referred_application_id
      led_stat.ledger_master_id = ledger_master_id
      led_stat.ledger_status = "Pending"
      led_stat.referred_by_id = referred_by_id
      led_stat.transferred_by = user_id
      if led_stat.save
        logger.debug("send_referral_common--------NOTIFICATION FOR REFERAL WILL BE SENT**********")
        RegistrationRequestMailer.referral_request(client_user_email,task_id, referred_application_id ).deliver
        # render :json=> {status: :ok, message: "Referral Request was sent" }
        task = Task.find(task_id)
        task.transferable = false
        task.transfer_status = "Pending"
        task.save
        req_status = "ok"
        message = "Referral Request sent"
      end
    end
    return message, req_status
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


end
