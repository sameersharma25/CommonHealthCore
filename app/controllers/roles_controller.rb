class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /roles
  # GET /roles.json
  def index
    client_application_id = current_user.client_application_id.to_s
    @roles = Role.where(client_application_id: client_application_id)
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
    @abilities = Role.get_method_names

    logger.debug("the abilities are : #{@abilities}")
  end

  # GET /roles/1/edit
  def edit
    @abilities = Role.get_method_names
  end

  # POST /roles
  # POST /roles.json
  def create
    abilities = []
    client_application = current_user.client_application_id.to_s
    @abilities = Role.get_method_names
    @role = Role.new(role_params)
    params[:role][:role_abilities].each do |ability|
      abilities << ability.to_sym
    end
    @role.role_abilities = [{"action"=> abilities, "subject"=>[:api]}]
    @role.client_application_id = client_application
    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: 'Role was successfully created.' }
        format.json { render :index, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    abilities = []
    params[:role][:role_abilities].each do |ability|
      abilities << ability.to_sym
    end
    @role.role_abilities = [{"action"=> abilities, "subject"=>[:api]}]
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tes_role

  end

  def wizard_add_new_role
    abilities = []
    client_application = current_user.client_application_id.to_s
    params[:abilities].each do |ability|
      abilities << ability.to_sym
    end
    @role = Role.new
    @role.role_abilities = [{"action"=> abilities, "subject"=>[:api]}]
    @role.client_application_id = client_application
    @role.role_name = params[:name]
    if @role.save
      respond_to do |format|
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.fetch(:role, {})
      params.require(:role).permit(:role_name)
    end
end
