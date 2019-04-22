class RegistrationRequestsController < ApplicationController
  before_action :set_registration_request, only: [:show, :edit, :update, :destroy]

  # GET /registration_requests
  # GET /registration_requests.json
  def index
    @registration_requests = RegistrationRequest.all
  end

  # GET /registration_requests/1
  # GET /registration_requests/1.json
  def show
  end

  # GET /registration_requests/new
  def new
    @registration_request = RegistrationRequest.new
  end

  # GET /registration_requests/1/edit
  def edit
  end

  # POST /registration_requests
  # POST /registration_requests.json
  def create
    @registration_request = RegistrationRequest.new(registration_request_params)

    respond_to do |format|
      if @registration_request.save
        RegistrationRequestMailer.registation_request(@registration_request).deliver
        format.html { redirect_to root_path, notice: 'Registration request was successfully created.' }
        format.json { render :show, status: :created, location: @registration_request }
      else
        format.html { render :new }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_requests/1
  # PATCH/PUT /registration_requests/1.json
  def update
    respond_to do |format|
      if @registration_request.update(registration_request_params)
        format.html { redirect_to @registration_request, notice: 'Registration request was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration_request }
      else
        format.html { render :edit }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_requests/1
  # DELETE /registration_requests/1.json
  def destroy
    @registration_request.destroy
    respond_to do |format|
      format.html { redirect_to registration_requests_url, notice: 'Registration request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_request
      @registration_request = RegistrationRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_request_params
      params.fetch(:registration_request, {})
      params.require(:registration_request).permit(:application_name, :application_url , :user_email, :external_application)
    end
end
