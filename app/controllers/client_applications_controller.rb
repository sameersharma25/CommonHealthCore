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
    logger.debug("the session count is *********************: #{user.sign_in_count}")
    logger.debug("the params are *********************: #{params.inspect}")
    if user.sign_in_count.to_s == "1"
      # rr = RegistrationRequest.find_by(user_email: user.email)
      # rr.invitation_accepted = true
      # rr.save
      logger.debug("REDIRECTING TO THE NEW STEPS****************")
      redirect_to after_signup_path(:role)
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

    table_name = 'contact_management_1'
    params = {
        table_name: table_name,
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    @result = dynamodb.scan(params)[:items]

    logger.debug("the RESULT OF THE SCAN IS : #{@result}************************")

  end

  def get_contact_management
    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    table_name = 'contact_management_1'

    parameters = {
        table_name: table_name,
        key: {
            OrganizationName_Text: params["org_name"]
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

    s3 = Aws::S3::Resource.new(
        region: "us-east-1",
        access_key_id: 'AKIAIJAVNKTMYWWYTF3Q',
        secret_access_key: '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'
    )
    s3.bucket('chcplugin').object('AdWord.zip').get(response_target: 's3://chcplugin/AdWord.zip')

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client_application
    @client_application = ClientApplication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_application_params
    # params.fetch(:client_application, {})
    params.require(:client_application).permit(:name, :application_url,:service_provider_url, users_attributes: [:name, :email, :_destroy],
    notification_rules_attributes: [:appointment_status, :time_difference,:subject, :body])
  end
end
