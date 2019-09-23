class TermsPrivaciesController < ApplicationController
  before_action :set_terms_privacy, only: [:show, :edit, :update, :destroy]

  # GET /terms_privacies
  # GET /terms_privacies.json
  def index
    ca_id = current_user.client_application_id
    @terms_privacies = TermsPrivacy.where(client_application_id: ca_id).entries
  end

  # GET /terms_privacies/1
  # GET /terms_privacies/1.json
  def show
  end

  # GET /terms_privacies/new
  def new
    @terms_privacy = TermsPrivacy.new 
  end

  # GET /terms_privacies/1/edit
  def edit
  end

  # POST /terms_privacies
  # POST /terms_privacies.json 
  def create
    @terms_privacy = TermsPrivacy.new(terms_privacy_params)
    @terms_privacy.client_application_id = current_user.client_application.id
    @terms_privacy.body = params['body']
    
    respond_to do |format|
      if @terms_privacy.save
        format.html { redirect_to @terms_privacy, notice: 'Terms privacy was successfully created.' }
        format.json { render :show, status: :created, location: @terms_privacy }
      else
        format.html { render :new }
        format.json { render json: @terms_privacy.errors, status: :unprocessable_entity }
      end
    end
  end 

  # PATCH/PUT /terms_privacies/1
  # PATCH/PUT /terms_privacies/1.json
  def update
    @terms_privacy.body = params['body']
    @terms_privacy.save 
    respond_to do |format|
      if @terms_privacy.update(terms_privacy_params)
        format.html { redirect_to @terms_privacy, notice: 'Terms privacy was successfully updated.' }
        format.json { render :show, status: :ok, location: @terms_privacy }
      else
        format.html { render :edit }
        format.json { render json: @terms_privacy.errors, status: :unprocessable_entity }
      end
    end
  end 

  # DELETE /terms_privacies/1
  # DELETE /terms_privacies/1.json
  def destroy
    @terms_privacy.destroy
    respond_to do |format|
      format.html { redirect_to terms_privacies_url, notice: 'Terms privacy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terms_privacy
      @terms_privacy = TermsPrivacy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terms_privacy_params
          params.require(:terms_privacy).permit(:body)
    end
end
