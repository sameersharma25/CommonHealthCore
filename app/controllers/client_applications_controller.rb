class ClientApplicationsController < ApplicationController
  before_action :set_client_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /client_applications
  # GET /client_applications.json
  def index
    user = current_user
    @client_application = current_user.client_application
    logger.debug("the session is *********************: #{session[:user_id]}")
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
    @client_application = ClientApplication.new(client_application_params)
    # @client_application.client_representative_id = current_client_representative

    respond_to do |format|
      if @client_application.save
        format.html { redirect_to @client_application, notice: 'Client application was successfully created.' }
        format.json { render :show, status: :created, location: @client_application }
      else
        format.html { render :new }
        format.json { render json: @client_application.errors, status: :unprocessable_entity }
      end
    end
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client_application
    @client_application = ClientApplication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_application_params
    # params.fetch(:client_application, {})
    params.require(:client_application).permit(:name, :application_url, users_attributes: [:name, :email, :_destroy])
  end
end
