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

    logger.debug("the RESULT OF THE SCAN IS : #{@result}************************")

  end

  def get_contact_management
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

    logger.debug("the Result of the get entry is : #{@result}")

    respond_to do |format|
      format.html
      format.js
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
