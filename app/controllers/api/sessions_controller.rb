module Api
  class SessionsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:create]

    def create
      user = User.find_by(email: params[:email])

      if user&.valid_password?(params[:password])
        render json: user.as_json(only: [:email, :authentication_token,:cc, :application_representative, :pcp]),status: :created
      else
        render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
      end


    end

    def destroy
      logger.debug("In the session destroy method")
    end

  end
end