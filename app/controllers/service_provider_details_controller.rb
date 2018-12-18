require 'csv'
require 'net/http'
require 'uri'
require 'json'

class ServiceProviderDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service_provider_detail, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /service_provider_details
  # GET /service_provider_details.json
  def index
    client_application_id = current_user.client_application_id.to_s
    @service_provider_details = ServiceProviderDetail.where(client_application_id: client_application_id)
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
    # filtering_fields = params[:filtering_fields].split("\r\n")
    logger.debug("the fields are: #{@service_provider_detail.inspect}")
    # @service_provider_detail.filtering_fields = params[:service_provider_detail][:filtering_fields].to_json
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

  def filter_field_values
    @field_type = params[:field_type]

    respond_to do |format|
      format.js
    end
  end

  def filter_page

    # input = {"Name": {type: "Input", value: a }, "Adult": {type: "Dropdown", value: b}}
    filter_fields = params[:filter]
    a = 'Apple'
    b = 'Not Accepting'
    c = "99203"
    d = "1"
    # input = {"Billing_Zip/Postal_Code": {type: "zipcode", value: c },  "Adult": {type: "Dropdown", value: b} }
    input = {"Billing_Zip/Postal_Code": {type: "zipcode", value: c },  "ABCD": {type: "Dropdown", value: d} }
    # input = {"Name": {type: "Input", value: a }, "Adult": {type: "Dropdown", value: b}}
    # input = {}

    # if filter_fields == "zip_adult"
    # input = zip_adult
    # elsif filter_fields == "name_adult"
    #   input = name_adult
    # else
    #   input = {}
    # end


    logger.debug("the value of input is : #{input}")

    uri = URI("https://aokx9crg6l.execute-api.us-west-2.amazonaws.com/post_hash")
    header = {'Content-Type' => 'text/json'}

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, header)
    request.body = input.to_json

    logger.debug(" the request body is : #{request}")
    response = http.request(request)
    @response_body =JSON.parse(response.body)
    # @response_body = []
    # JSON.parse(response.body)
    # logger.debug("the response is : #{@response_body.inspect}" )
    # respond_to do |format|
    #   format.js
    #   format.html
    # end

  end

  def add_filter_fields
    name = params[:name]
    values = params[:values].gsub(" ", "").split(',')
    type = params[:type]
    logger.debug("name is : #{name}***** value is : #{values},****** type is : #{type}")
    @filter_field_hash = {"#{name}" => {type: "#{type}", values: "#{values}"}}
    logger.debug("the filter hash is : #{@filter_field_hash}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_provider_detail
      @service_provider_detail = ServiceProviderDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_provider_detail_params
      params.fetch(:service_provider_detail, {})
      params.require(:service_provider_detail).permit(:service_provider_name, :provider_type, :share, :data_storage_type, :service_provider_api,:client_application_id, :provider_data_file, filtering_fields: {})
    end
end
