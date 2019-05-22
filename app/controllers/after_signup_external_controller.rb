class AfterSignupExternalController < ApplicationController
  # include Wicked::Wizard

  # steps :api_setup

  def show
    logger.debug("Entering the afterSignupExternal Show action*********************")

    # if current_user.application_representative?
    #   @user = User.find_by(email: params[:email])
    # if !current_step_index.nil?
    #   @current_step = current_step_index + 1
    #   actual_total_steps = steps.count
    #   @total_steps = actual_total_steps - 1
    #   logger.debug("*******************the total steps are : #{@total_steps}")
    # end

    @user = current_user
    if @user.sign_in_count.to_s == "1"
      # @user = current_user
      @user.sign_in_count += 1
      @user.save
    end
    client_application = @user.client_application
    @client_application_id = @user.client_application.id.to_s
    # case step
    #   when :api_setup
        logger.debug("after the WHEN api_setup *************************************")
        @external_api_setup = ExternalApiSetup.new


    # end

    # render_wizard

  end

  def index

    logger.debug("IN the index of the after signup External*******************")
    @user = current_user
    if @user.sign_in_count.to_s == "1"
      # @user = current_user
      @user.sign_in_count += 1
      @user.save
    end
    client_application = @user.client_application
    @client_application_id = @user.client_application.id.to_s
    # case step
    #   when :api_setup
    logger.debug("after the WHEN api_setup *************************************")
    @external_api_setup = ExternalApiSetup.new

  end

  def edit

    logger.debug("IN the EDIT of the after signup External*******************")
    @user = current_user
    client_application = @user.client_application
    @client_application_id = @user.client_application.id.to_s

    @external_api_setups = ClientApplication.find(params[:id]).external_api_setups
    @send_patient_api = ClientApplication.find(params[:id]).external_api_setups.where(api_for: "send_patient").first
    @remove_patient_api = ClientApplication.find(params[:id]).external_api_setups.where(api_for: "remove_patient").first
    logger.debug("after the WHEN api_setup #{@external_api_setups.entries}*************************************")
  end

  def update
    # case step
    #   when :api_setup
    client_id  = params[:client_id]
    api_arrayyyyy = params["api_array"]
    logger.debug("this current user login count #{current_user.sign_in_count.to_s}")
    logger.debug("the update STEP action of the external app wizard*********** the API ARRAY IS : #{api_arrayyyyy}")
    api_arrayyyyy.each do |k, v|
      api_for = v["id"]
      external_api = ExternalApiSetup.where(client_application_id: client_id , api_for: api_for)[0]
      logger.debug("the update STEP action of the external app wizard*********** the API FOR IS : #{external_api}")
      if !external_api.nil?
        logger.debug("the update STEP action of the external app wizard*********** EAS not NILL ")
        external_api.api_name = v["text"]
        external_api.save
      else
        logger.debug("the update STEP action of the external app wizard*********** EAS IS NILL ")
        eas = ExternalApiSetup.new
        eas.client_application_id = client_id
        eas.api_for = v["id"]
        eas.api_name = v["text"]
        eas.save
      end
    end
    #     jump_to(:wicked_finish)
    #     redirect_to :controller => "client_applications", :action => 'index'

    # end

    # render "./app/views/client_applications#index"

  end



end
