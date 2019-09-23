class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :destroy]
  before_action :client_roles
  load_and_authorize_resource
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    # logger.debug("the roles for the client are : #{@roles.inspect}")
  end

  # GET /users/1/edit
  def edit
    @user = @user
    # @user_role = @user.role
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    client_application = current_user.client_application.id
    # @user.client_application = client_application
    logger.debug("USER IS : #{@user.inspect}")
    # @user = User.invite!(email: params[:user][:email], name: params[:user][:name])
    send_invite_to_user(params[:user][:email], client_application, params[:user][:name],params[:user][:roles] )
    respond_to do |format|
      if @user.save
        logger.debug("user is SAVED")
        format.html { redirect_to root_path, notice: 'User was successfully Invited.' }
        # format.json { render :show, status: :created, location: @user }
      else
        logger.debug("user is NOT SAVED")
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_invite_to_user(email, client_application,name,role)
    @user = User.invite!(email: email, name: name, roles: role)
    @user.update(client_application_id: client_application , application_representative: true)

  end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find_by(email: params[:user][:email])
    @user.roles = params[:user][:roles]
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#"role_ids"=>["user_roles_5bfdb71358f01a58b4915c63", "user_roles_5bfdc32e58f01a58b4915c6f"]
  def wizard_add_user
    role_ids = params[:role_ids]
    roles = []
    role_ids.each do |rid|
      roles.push(rid.split("_")[2])
    end
    name = params[:name]
    email = params[:email]
    client_application = current_user.client_application.id
    if send_invite_to_user(email, client_application, name,roles)
      respond_to do |format|
        @users = User.where(client_application_id: client_application)
        format.js
      end
    end

  end

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first

      # Uncomment the section below if you want users to be created if they don't exist
      # unless user
      #     user = User.create(name: data['name'],
      #        email: data['email'],
      #        password: Devise.friendly_token[0,20]
      #     )
      # end
      user
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def client_roles
    client_application = ClientApplication.find(current_user.client_application_id.to_s)
    @roles = client_application.roles
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    # params.fetch(:user, {})
    params.require(:user).permit(:name, :email, :client_application,:roles, :phone_number)
  end

end