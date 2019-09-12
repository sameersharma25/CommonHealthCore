class AboutUsController < ApplicationController
  before_action :set_about_u, only: [:show, :edit, :update, :destroy]

  # GET /about_us
  # GET /about_us.json
  def index
    ca_id = current_user.client_application_id
    @about = AboutU.where(client_application_id: ca_id).entries

    logger.debug("The Id #{ca_id}")
    @about_us = @about.first
    if !@about_us.present? 
      redirect_to new_about_u_path 
    end 

  end

  # GET /about_us/1
  # GET /about_us/1.json
  def show 

  end

  # GET /about_us/new
  def new
    @about_u = AboutU.new
  end

  # GET /about_us/1/edit
  def edit
        client_application_id = current_user.client_application_id.to_s

  end

  # POST /about_us
  # POST /about_us.json
  def create

    @about_u = AboutU.new
    @about_u.body = params['body']
    @about_u.client_application_id = current_user.client_application.id
    @about_u.save

    respond_to do |format|
      if @about_u.save
        format.html { redirect_to @about_u, notice: 'About us was successfully created.' }
        format.json { render :show, status: :created, location: @about_u }
      else
        format.html { render :new }
        format.json { render json: @about_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /about_us/1
  # PATCH/PUT /about_us/1.json
  def update
    @about_u.body = params['body']
    @about_u.save

    respond_to do |format|
      if @about_u.update(about_u_params)
        format.html { redirect_to @about_u, notice: 'About us was successfully updated.' }
        format.json { render :show, status: :ok, location: @about_u }
      else
        format.html { render :edit }
        format.json { render json: @about_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /about_us/1
  # DELETE /about_us/1.json
  def destroy
    @about_u.destroy
    respond_to do |format|
      format.html { redirect_to about_us_url, notice: 'About us was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_about_u
      @about_u = AboutU.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def about_u_params
      params.fetch(:about_u, {})
    end
end
