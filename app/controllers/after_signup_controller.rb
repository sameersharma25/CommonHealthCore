class AfterSignupController < ApplicationController
  include Wicked::Wizard

  # steps :update_details_and_add_users#, :notification_rules
  steps :role,:users,:status,:alert_workflow, :service_provider, :default_settings#, :notification_rules


  def show
    logger.debug("Entering the afterSignup Show action*********************")

    # if current_user.application_representative?
    #   @user = User.find_by(email: params[:email])
    if !current_step_index.nil?
      @current_step = current_step_index + 1
      @total_steps = steps.count
    end

    @user = current_user
    if @user.sign_in_count.to_s == "1"
      # @user = current_user
      @user.sign_in_count += 1
      @user.save
    end
    client_application = @user.client_application
    @client_application_id = @user.client_application.id.to_s
    # @role = Role.new
    case step
    when :role
      @role = Role.new
      @abilities = Role.get_method_names
      @roles = Role.where(client_application_id: client_application)
    when :users
      @user = User.new
      @roles = Role.where(client_application_id: client_application)
      @users = User.where(client_application_id: client_application)
    when :status
      @status = Status.new
      @statuses = Status.where(client_application_id: client_application)

    when :service_provider
      @service_provider_detail = ServiceProviderDetail.new

    when :alert_workflow
      @notification_rule = NotificationRule.new
      @statuses = Status.where(client_application_id: client_application)
      @notification_rules = NotificationRule.where(client_application_id: client_application)
    when :users
      @user = User.new

    when :default_settings   #wicked_finish
      logger.debug("IN SHOW default setting *****************")
      # @user = current_user
      # @user.sign_in_count += 1
      # @user.save
      set_defaults_values
      jump_to(:wicked_finish)

    end

      logger.debug("users step- current_user = #{params.inspect}")
      #@current_step = current_step_index + 1
      @total_steps = steps.count
      render_wizard
    # end
  end

  def update
    # @user = current_user
    # logger.debug("steps update methosd****** #{params.inspect}")
    # @client_application = ClientApplication.find_by(application_url: params[:client_application][:application_url])
    # @client_application.attributes = client_application_params
    # if params[:client_application][:users_attributes]
    #   params[:client_application][:users_attributes].keys.each do |cu|
    #     logger.debug("steps update methosd****** #{params[:client_application][:users_attributes][cu]["email"]}")
    #     email = params[:client_application][:users_attributes][cu]["email"]
    #       @user = User.invite!(email: email)
    #       @user.update(client_application_id: @client_application)
    #   end
    # end
    case step
      when :role
        @role = Role.new
        @role.role_name = params[:role][:role_name]
        @role.client_application_id = params[:client_id]
        logger.debug("the role was saved*****************")
        render_wizard @role
      when :users
        @user = User.new
        @user = current_user
        client_application = @user.client_application
        @roles = Role.where(client_application_id: client_application)
        render_wizard @user
      when :status
        @status = Status.new
        @status.status = params[:status][:status]
        @status.client_application_id = params[:client_id]
        logger.debug("the status BEFORE saved*****************")

        render_wizard @status

      when :alert_workflow
        notificaiton_rule = NotificationRule.new
        notificaiton_rule.appointment_status = params[:notification_rule][:appointment_status]
        notificaiton_rule.time_difference = params[:notification_rule][:time_difference]
        # notificaiton_rule.user_type = params[:notification_rule][:user_type]
        # notificaiton_rule.subject = params[:notification_rule][:subject]
        # notificaiton_rule.body = params[:notification_rule][:body]
        # notificaiton_rule.client_application_id = params[:client_id]
        # notificaiton_rule.save

        render_wizard notificaiton_rule


      when :service_provider
        @service_provider_detail = ServiceProviderDetail.new
        service_provider_detail = ServiceProviderDetail.new
        service_provider_detail.service_provider_name = params[:service_provider_detail][:service_provider_name]
        service_provider_detail.provider_type = params[:service_provider_detail][:service_provider_name]
        service_provider_detail.data_storage_type = params[:service_provider_detail][:data_storage_type]
        service_provider_detail.service_provider_api = params[:service_provider_detail][:service_provider_api]
        service_provider_detail.client_application_id = params[:client_id]
       if service_provider_detail.save
        jump_to(:wicked_finish)
          render_wizard service_provider_detail

          # next_step
        end
        # jump_to(:wicked_finish)
        # next_step
    end
    logger.debug("the paramas in the update wizard is : #{params.inspect}")

  end




  def set_defaults_values
    logger.debug("IN THE set default values method***************")
    user = current_user
    client_application_id = user.client_application.id.to_s

    default_client = ClientApplication.find_by(name: "default_application")
    logger.debug("the default client is #{default_client.inspect}")

    # Creating roles
    default_client.roles.each do |role|
      new_role = Role.new
      new_role.role_name = role.role_name
      new_role.role_abilities = role.role_abilities
      new_role.client_application_id = client_application_id
      new_role.save
    end

    # Creating Status
    default_client.statuses.each do |status|
      new_status = Status.new
      new_status.status = status.status
      new_status.client_application_id = client_application_id
      new_status.save
    end

    # Creating Notification Rules
    default_client.notification_rules.each do |nr|
      new_nr = NotificationRule.new
      new_nr.time_difference = nr.time_difference
      new_nr.subject = nr.subject
      new_nr.body = nr.body
      new_nr.notification_type = nr.notification_type
      new_nr.user_type = nr.user_type
      new_nr.client_application_id = client_application_id
      new_nr.appointment_status = nr.appointment_status
      new_nr.save
    end

  end

  private

  def client_application_params
    # params.fetch(:client_application, {})
    params.require(:client_application).permit(:name, :application_url,:id,:email, users_attributes: [:id,:name, :email, :_destroy])
  end
end




# ["create_task", "create_referral","referral_list","update_referral","task_list","update_task","edit_provider_details","filter_provider",
# "send_message", "message_list","get_messages",   ]