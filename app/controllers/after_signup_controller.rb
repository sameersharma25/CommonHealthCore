class AfterSignupController < ApplicationController
  include Wicked::Wizard

  steps :update_details_and_add_users, :notification_rules


  def show
    # if current_user.application_representative?
      @user = User.find_by(email: params[:email])
      @client_application = @user.client_application
      logger.debug("users step- current_user = #{params.inspect}")
      #@current_step = current_step_index + 1
      @total_steps = steps.count
      render_wizard
    # end
  end

  def update
    logger.debug("steps update methosd****** #{params.inspect}")
    @client_application = ClientApplication.find_by(application_url: params[:client_application][:application_url])
    @client_application.attributes = client_application_params
    if params[:client_application][:users_attributes]
      params[:client_application][:users_attributes].keys.each do |cu|
        logger.debug("steps update methosd****** #{params[:client_application][:users_attributes][cu]["email"]}")
        email = params[:client_application][:users_attributes][cu]["email"]
          @user = User.invite!(email: email)
          @user.update(client_application_id: @client_application)
      end
    end
     render_wizard@client_application
  end

  private

  def client_application_params
    # params.fetch(:client_application, {})
    params.require(:client_application).permit(:name, :application_url,:id,:email, users_attributes: [:id,:name, :email, :_destroy])
  end
end
