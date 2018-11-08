class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json
  def index
    #Will need to call status in order by statusid? or?
    #@statuses = Status.order(:position)

    client_application_id = current_user.client_application_id.to_s
    @statuses = Status.where(client_application_id: client_application_id)
  end

  def sort
    params[:status].each_with_index do |id, index|
      Status.where(id: id).update_all(position: index + 1)
    end 
    head :ok
  end 

  # GET /statuses/1
  # GET /statuses/1.json
  def show
      @status = Status.find(params[:id])
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(status_params)
    client_application_id = current_user.client_application_id.to_s
    @status.client_application_id = client_application_id
    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.fetch(:status, {})
      params.require(:status).permit(:status,:title, :status_id)
    end
end
