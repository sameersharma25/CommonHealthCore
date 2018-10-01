class ServiceProviderDetailsController < ApplicationController
  before_action :set_service_provider_detail, only: [:show, :edit, :update, :destroy]

  # GET /service_provider_details
  # GET /service_provider_details.json
  def index
    @service_provider_details = ServiceProviderDetail.all
  end

  # GET /service_provider_details/1
  # GET /service_provider_details/1.json
  def show
  end

  # GET /service_provider_details/new
  def new
    @client_application = current_user.client_application_id.to_s
    @service_provider_detail = ServiceProviderDetail.new
  end

  # GET /service_provider_details/1/edit
  def edit
    @client_application = current_user.client_application_id.to_s
  end

  # POST /service_provider_details
  # POST /service_provider_details.json
  def create
    @service_provider_detail = ServiceProviderDetail.new(service_provider_detail_params)

    respond_to do |format|
      if @service_provider_detail.save
        # format.html { redirect_to @service_provider_detail, notice: 'Service provider detail was successfully created.' }
        format.html{redirect_to service_provider_details_path, notice: 'Service provider detail was successfully created.'}
        format.json { render :show, status: :created, location: @service_provider_detail }
      else
        format.html { render :new }
        format.json { render json: @service_provider_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_provider_details/1
  # PATCH/PUT /service_provider_details/1.json
  def update
    respond_to do |format|
      if @service_provider_detail.update(service_provider_detail_params)
        # format.html { redirect_to @service_provider_detail, notice: 'Service provider detail was successfully updated.' }
        format.html{redirect_to service_provider_details_path,notice: 'Service provider detail was successfully updated.'}
        format.json { render :show, status: :ok, location: @service_provider_detail }
      else
        format.html { render :edit }
        format.json { render json: @service_provider_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_provider_details/1
  # DELETE /service_provider_details/1.json
  def destroy
    @service_provider_detail.destroy
    respond_to do |format|
      format.html { redirect_to service_provider_details_url, notice: 'Service provider detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def internal_extrnal_storage

    @storage_type = params[:storage_type]

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_provider_detail
      @service_provider_detail = ServiceProviderDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_provider_detail_params
      params.fetch(:service_provider_detail, {})
      params.require(:service_provider_detail).permit(:service_provider_name, :provider_type, :share, :data_storage_type, :service_provider_api,:client_application_id)
    end
end
