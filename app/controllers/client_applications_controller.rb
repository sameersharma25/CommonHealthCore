class ClientApplicationsController < ApplicationController
  before_action :set_client_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:new, :create, :contact_management]

  # GET /client_applications
  # GET /client_applications.json
  def index  
    user = current_user
    @client_application = current_user.client_application
    @registration_request = RegistrationRequest.all
    @notification_rules = @client_application.notification_rules
    # @referred_applications = LedgerStatus.where(referred_application_id: @client_application.id.to_s)
    @referred_applications = LedgerStatus.all

    logger.debug("the session count is *********************: #{user.sign_in_count}, LEDGER STATIS : #{@referred_applications.entries}")
    logger.debug("the params are *********************: #{params.inspect}")
    if user.sign_in_count.to_s == "1" && user.admin == true
      # rr = RegistrationRequest.find_by(user_email: user.email)
      # rr.invitation_accepted = true
      # rr.save
      if @client_application.external_application == true
        logger.debug("REDIRECTING TO THE API STEPS for EXTERNAL APPLICATION ****************")
        # redirect_to after_signup_external_path(:api_setup)
        redirect_to after_signup_external_index_path

      else
        logger.debug("REDIRECTING TO THE NEW STEPS****************")
        redirect_to after_signup_path(:role)
      end

    end
  end

  # GET /client_applications/1
  # GET /client_applications/1.json
  def show
  end

  # GET /client_applications/new
  def new
    @client_application = ClientApplication.new
  end

  # GET /client_applications/1/edit
  def edit
  end

  # POST /client_applications
  # POST /client_applications.json
  def create
    logger.debug("************THE PARAMETERS IN create Client Applicaiton ARE: #{params.inspect}")
    @client_application = ClientApplication.new(client_application_params)
    respond_to do |format|
      if @client_application.save
        admin_role = Role.create(client_application_id: @client_application.id.to_s ,role_name: "Admin", role_abilities: [{"action"=>[:manage], "subject"=>[:all]}])
       if params[:client_application][:user][:email]
         user_invite = send_invite_to_user(params[:client_application][:user][:email],@client_application,
                                           params[:client_application][:user][:name], admin_role.id.to_s )
       end
        format.html { redirect_to @client_application, notice: 'Client application was successfully created.' }
        format.json { render :show, status: :created, location: @client_application }
      else
        format.html { render :new }
        format.json { render json: @client_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_invite_to_user(email, client_application,name,role)
    logger.debug("********* In the send user invite method")
    @user = User.invite!(email: email, name: name,roles: [role])
    @user.update(client_application_id: client_application , application_representative: true, admin: true)
  end

  def register_client
    @client_application = ClientApplication.new
  end
  # PATCH/PUT /client_applications/1
  # PATCH/PUT /client_applications/1.json
  def update
    respond_to do |format|
      if @client_application.update(client_application_params)
        logger.debug("IN THE APPLICATION UPDATE*************************")
        format.html { redirect_to @client_application, notice: 'Client application was successfully updated.' }
        format.json { render :show, status: :ok, location: @client_application }
      else
        format.html { render :edit }
        format.json { render json: @client_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_applications/1
  # DELETE /client_applications/1.json
  def destroy
    @client_application.destroy
    respond_to do |format|
      format.html { redirect_to client_applications_url, notice: 'Client application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def all_details
    # @client_application = @client_application
    user = current_user
    @client_application = current_user.client_application
  end

  def save_all_details

    @client_application = current_user.client_application
    @client_application.update(client_application_params)
    redirect_to root_path

  end

  def send_application_invitation
    logger.debug("*************the id is: #{params[:id]}")
    rr = RegistrationRequest.find(params[:id])

    ca = ClientApplication.new
    ca.name = rr.application_name
    ca.application_url = rr.application_url
    ca.external_application = rr.external_application
    ca.master_application_status = false

    if ca.save
      admin_role = Role.create(client_application_id: ca.id.to_s ,role_name: "Admin", role_abilities: [{"action"=>[:manage], "subject"=>[:all]}])
      if rr.user_email
        user_invite = send_invite_to_user(rr.user_email,ca,
                                          rr.application_name, admin_role.id.to_s )
        logger.debug("the user Invite value is : #{user_invite} -------#{user_invite.class}")
        if user_invite == true
          rr.invited = true
          rr.save
        end
      end
    end

  end

  def contact_management
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")

    table_name = 'contact_management'
    params = {
        table_name: table_name,
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    @result = dynamodb.scan(params)[:items] #.sort_by!{|k| k["created_at"]}.reverse!

    @pending_results = @result.select{|p| p["status"] == "Pending"}

    logger.debug("the RESULT OF THE SCAN IS : ************************")

    #@masterStatus = @client_application.master_application_status

    user = current_user 
    @client_application = current_user.client_application
    @masterStatus = @client_application.master_application_status

    respond_to do |format|
      format.html
      format.js
    end


  end

  def get_contact_management #modal
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    table_name = 'contact_management'

    parameters = {
        table_name: table_name,
        key: {
            # OrganizationName_Text: params["org_name"]
            url: params[:org_url]
        }
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    @result = dynamodb.get_item(parameters)[:item]

    #logger.debug("the Result of the get entry is : #{@result}")
    @result.each do |k,v| 
      logger.debug("Key::: #{k}: Value::: #{v}")
      if k == "status"
        #logger.debug("FOUND #{k}::: #{v}")
      elsif k == "userName"
        #logger.debug("FOUND #{k}::: #{v}")
      elsif k == "geoScope"
        #logger.debug("FOUND #{k}::: #{v}")
          @geoScope = v
      elsif k == "programs"
        #logger.debug("FOUND #{k}::: #{v}")
          @programs = v
          @programHash = {}
          i=0
          while i < @programs.length do 
                  @programs[i].each do |q,w|
                    logger.debug("KEY::: #{q}:VALUE:::#{w}")
                      case q
                          when 'ProgramDescription'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @programHash[q] = textOnlyArray
                          when 'ProgramReferences'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @programHash[q] = textOnlyArray
                          when 'ServiceDescription'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @programHash[q] = textOnlyArray
                          when 'PopulationDescription'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @programHash[q] = textOnlyArray
                      end 
                      if w.class != Array
                        @programHash[q] = w
                      end 

                  end
                  logger.debug("BREAK ####}")
              i+=1
          end 
      elsif k == "orgSites"
        logger.debug("FOUND #{k}::: #{v}")
          @orgSites = v
          @siteHash = {}
          @poc = {}
          i=0
          while i < @orgSites.length do 
                  @orgSites[i].each do |q,w|
                    logger.debug("KEY::: #{q}:VALUE:::#{w}")
                      case q
                          when 'SiteReference_TEXT'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @siteHash[q] = textOnlyArray
                          when 'addrOne_Text'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @siteHash[q] = textOnlyArray
                          when 'ServiceDescription'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @siteHash[q] = textOnlyArray
                          when 'ProgramDescription'
                            textOnlyArray = []
                            w.each do |x|
                                textvalue = x['text']
                                textOnlyArray.push(textvalue)
                            end 
                            @siteHash[q] = textOnlyArray
                          when 'POCs'
                            logger.debug("HERE #{w}")
                            w[0].each do |k,v|
                                @poc[k]= v
                            end 
                      end 
                      if w.class != Array
                        @siteHash[q] = w
                      end 

                  end
                  logger.debug("BREAK ####}")
              i+=1
          end


      elsif k == "organizationName"
        logger.debug("FOUND #{k}::: #{v}")
          @organizationName = v
      end     
    end 



 

  end

  def plugin

    respond_to do |format|
      format.html
      format.js
    end

  end

  def download_plugin

    # s3 = Aws::S3::Resource.new(
    #     region: "us-east-1",
    #
    # )
    # zip_file= s3.bucket('chcplugin').object('AdWord.zip').get()
    #
    # logger.debug("the file output is : #{zip_file.body.inspect}")

    key = 'AdWord.zip'
    bucketName = "chcplugin"
    localPath = "/Users/harshavardhangandhari/RSI"
    # (1) Create S3 object
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    # (2) Create the source object
    sourceObj = s3.bucket(bucketName).object(key)
    # (3) Download the file
    sourceObj.get(response_target: localPath)
    puts "s3://#{bucketName}/#{key} has been downloaded to #{localPath}"
    # s3.bucket('chcplugin').object('AdWord.zip').send_file('/Users/harshavardhangandhari/RSI/')

    # bucket = s3.bucket('chcplugin')
    #
    # bucket.objects.limit(50).each do |item|
    #   puts "Name:  #{item.key}"
    #   puts "URL:   #{item.presigned_url(:get)}"
    # end

  end

  def define_parameters
    @parameter_for = params[:api_for]
    @client_application_id = params[:client_application_id]

    respond_to do |format|
      format.html
      format.js
    end
  end


  def external_api_setup
    if !params[:expected_paramas].blank?
      @hash_keys_array = []
      @chc_parameters = []
      eval(params[:expected_paramas]).each do |key, value|
        @hash_keys_array.push(key)
      end
      @client_application_id = params[:client_application_id]
      @api_name = params[:api_name]
      logger.debug("the hash is : #{eval(params[:expected_paramas])}")
      eas = ExternalApiSetup.new
      eas.client_application_id = @client_application_id
      eas.api_for = params[:api_for]
      eas.expected_parameters = eval(params[:expected_paramas])
      eas.save
      @external_api_id = eas.id.to_s

      logger.debug("the saved EAS is : #{eas.inspect}************** the keys are : #{@hash_keys_array}********external_api_id : #{@external_api_id}")
      parameter_exceptions = ["_id", "created_at", "updated_at"]

      model_array = [Patient, Referral, Task]

      model_array.each do |m|
        m.fields.keys.each do |p|
          if !parameter_exceptions.include?(p)
            @chc_parameters.push(p)
          end
        end
      end

      @chc_parameters.sort!
      logger.debug("the CHC parameters are : #{@chc_parameters}**************")

      respond_to do |format|
        format.html
        format.js
      end
    else
      logger.debug("in the else block of empty params")
      @show_error_messageg = true
      respond_to do |format|
        format.html
        format.js
      end
    end

  end

  def parameters_mapping
    logger.debug("IN the parameters mapping method************")
    external_parameters = params[:extermal_parameter]
    chc_parameters = params[:chc_parameter]
    external_api_id = params[:external_application_id]
    i = 0
    external_parameters.each do |ep|
      logger.debug("in the extermal parameters loop******************")
      mp = MappedParameter.new
      logger.debug("after creating new mappedparameters #{mp.inspect}******************")
      mp.external_api_setup_id = external_api_id
      mp.external_parameter = ep
      mp.chc_parameter = chc_parameters[i]
      logger.debug("after ADDING mappedparameters #{mp.inspect}******************")
      if mp.save
        logger.debug('the MP WAS SAVED***********')
      else
        logger.debug('NOT SAVEDDDDDDDDDDDd')
      end
      i+=1
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def get_patients
    user = current_user
    client_application_id = current_user.client_application.id.to_s
    @patients = Patient.where(client_application_id: client_application_id).order(last_name: :asc)
    @referrals = Referral.where(client_application_id: client_application_id).order(created_at: :desc).limit(3)

  end

  def send_task
    input = {task_id: params[:task_id], external_application_id: "5ab9145d58f01ad9374afd11" }
    uri = URI("http://localhost:3000/api/send_patient")
    header = {'Content-Type' => 'application/json'}
    http = Net::HTTP.new(uri.host, uri.port)
    puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
    # http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, header)
    request.body = input.to_json

    # Send the request
    response = http.request(request)
    puts "response #{response.body}"
    puts JSON.parse(response.body)
  end

  def check_duplicate_entries
    logger.debug("IN THE DUPLICATE METHOD*************")
    catalog = params[:catalog]
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    table_name = 'master_provider'
    org_url = params[:org_url]
    params = {
        table_name: table_name,
        key_condition_expression: " #ur = :u",
        expression_attribute_names: {
            "#ur" => "url"
        },
        expression_attribute_values: {
            ":u" => org_url
        }
    }
    begin
      result = dynamodb.query(params)
      # puts "Query succeeded."
      logger.debug("the RESULT IS : #{result[:items]}")
      if !result[:items].empty?
        items = result[:items]
        logger.debug("RESULT IS NOT EMPTY!!!!!!!!!!!*****************")
        duplicates = check_for_sites(catalog, items)
      else
        logger.debug("THE RESULT IS EMPTY!!!!!!!!!!*****************")
        duplicates = []
      end
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts "Unable to query table:"
      puts "#{error.message}"
    end
      @duplicates = duplicates
  end

  def check_for_sites(catalog, items)

    catlog_zip = []
    item_zip = []
    duplicate_array = []
    catalog["orgSites"].each do|site|
      zip = site["Adrzip"]
      catlog_zip.push(zip)
    end

    items.each do |i|

      i["orgSites"].each do|site|
        zip = site["Adrzip"]
        item_zip.push(zip)
      end
      if item_zip == catlog_zip
        duplicate_array.push(i)
      end
    end
    logger.debug("**************THE DUPLICATE ARRAY IS : #{duplicate_array}")
    duplicate_array

  end

  ###Start Mason
  def send_for_approval
    logger.debug("YOU STILL KNOW RAILS")
    logger.debug("Collecting info #{params['orgName']} &&&URL #{params['url']}")
    dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
    parameters = {
        table_name: 'contact_management',
        key: {
            url: params["url"]
        },
        update_expression: "set #st = :s ",
        expression_attribute_values: {
            ":s" => 'Pending'
        },
        expression_attribute_names: { 
            "#st" => "status"
        },
        return_values: "UPDATED_NEW"
    }

        begin
          dynamodb1.update_item(parameters)
          render :json => {status: :ok, message: "Catalog Updated" }
        rescue  Aws::DynamoDB::Errors::ServiceError => error
          render :json => {message: error  }
        end      

  end

  def approve_catalog

  logger.debug("Collecting info #{params['orgName']} &&&URL #{params['url']}")
  dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
  parameters = {
      table_name: 'contact_management',
      key: {
          url: params["url"]
      },
      update_expression: "set #st = :s ",
      expression_attribute_values: {
          ":s" => 'Approved'
      },
      expression_attribute_names: { 
          "#st" => "status"
      },
      return_values: "UPDATED_NEW"
  }

      begin
        dynamodb1.update_item(parameters)
        insert_in_master_provider(params["url"])
        render :json => {status: :ok, message: "Catalog Updated" }
      rescue  Aws::DynamoDB::Errors::ServiceError => error
        render :json => {message: error  }
      end 
  end

  def insert_in_master_provider(url)

    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    table_name = 'contact_management'

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
    logger.debug("******************insert_in_master_provider #{result}")

    table_name1 = 'master_provider'

    params1 = {
        table_name: table_name1,
        item: result
    }

    begin
      dynamodb.put_item(params1)
      # render :json => { status: :ok, message: "Entry created successfully"  }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      render :json => {message: error  }
    end



  end



  def reject_catalog   #@@@
    logger.debug("YOU STILL KNOW RAILS2 #{[params]}")
    logger.debug("Collecting info #{params['orgName']} &&&URL #{params['url']}")
    dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
    parameters = {
        table_name: 'contact_management',
        key: {
            url: params["url"]
        },
        update_expression: "set #st = :s, #rr = :r ",
        expression_attribute_values: {
            ":s" => 'Rejected',
            ":r" => params["rejectReason"]

        },
        expression_attribute_names: { 
            "#st" => "status",
            "#rr" => "rejectReason"
        },
        return_values: "UPDATED_NEW"
    }

        begin
          dynamodb1.update_item(parameters)
          render :json => {status: :ok, message: "Catalog Updated" }
        rescue  Aws::DynamoDB::Errors::ServiceError => error
          render :json => {message: error  }
        end 

  end 
  def delete_catalog
    logger.debug("YOU STILL KNOW RAILS2 #{params['url']}")
    dynamodb1 = Aws::DynamoDB::Client.new(region: "us-west-2")
    parameters = {
        table_name: 'contact_management',
        key: {
            url: params["url"]
            #url: 'https://valleyymca.org'
        }
      }

    begin
      dynamodb1.delete_item(parameters)
      puts 'Deleted this rule'
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to delete movie:'
      puts error.message
    end
    #find by id and delete 
  end 


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client_application
    @client_application = ClientApplication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_application_params
    # params.fetch(:client_application, {})
    params.require(:client_application).permit(:name, :application_url,:service_provider_url, :accept_referrals,:client_speciality, #users_attributes: [:name, :email, :_destroy],
    notification_rules_attributes: [:appointment_status, :time_difference,:subject, :body])
  end
end
