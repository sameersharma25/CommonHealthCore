class NotificationRulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification_rule, only: [:show, :edit, :update, :destroy]


  # GET /notification_rules
  # GET /notification_rules.json
  def index
    client_application = current_user.client_application
    @notification_rules = client_application.notification_rules
    @notification_rule = NotificationRule.new
    @statuses = Status.where(client_application_id: client_application)
    @role = Role.where(client_application_id: client_application)
  end

  # GET /notification_rules/1
  # GET /notification_rules/1.json
  def show
  end

  # GET /notification_rules/new
  def new
    @notification_rule = NotificationRule.new
  end

  # GET /notification_rules/1/edit
  def edit
  end

  # POST /notification_rules
  # POST /notification_rules.json
  def create
    client_application = current_user.client_application
    @notification_rule = NotificationRule.new(notification_rule_params)
    @notification_rule.client_application = client_application
    # respond_to do |format|
    #   if @notification_rule.save
    #     @notification_rules = client_application.notification_rules
    #     # format.html #{ redirect_to @notification_rule, notice: 'Notification rule was successfully created.' }
    #     format.js
    #     # format.json { render :show, status: :created, location: @notification_rule }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @notification_rule.errors, status: :unprocessable_entity }
    #   end
    # end
    if @notification_rule.save
      @notification_rules = client_application.notification_rules
      respond_to do |format|
        format.js
      end
    end
  end

  # PATCH/PUT /notification_rules/1
  # PATCH/PUT /notification_rules/1.json
  def update
    respond_to do |format|
      if @notification_rule.update(notification_rule_params)
        format.html { redirect_to @notification_rule, notice: 'Notification rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification_rule }
      else
        format.html { render :edit }
        format.json { render json: @notification_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notification_rules/1
  # DELETE /notification_rules/1.json
  def destroy
    @notification_rule.destroy
    respond_to do |format|
      format.html { redirect_to notification_rules_url, notice: 'Notification rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def wizard_add_notification
    client_application_id = current_user.client_application_id.to_s
    notifiacation_rule = NotificationRule.new
    notifiacation_rule.appointment_status = params[:status]
    notifiacation_rule.time_difference = params[:time]
    notifiacation_rule.subject = params[:subject]
    notifiacation_rule.body = params[:body]
    notifiacation_rule.user_type = params[:user_type]
    notifiacation_rule.client_application_id = client_application_id
    if notifiacation_rule.save
      respond_to do |format|
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification_rule
      @notification_rule = NotificationRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_rule_params
      # params.fetch(:notification_rule, {})
      params.require(:notification_rule).permit(:appointment_status, :time_difference, :subject, :body, :user_type, :notification_type)
    end
end
