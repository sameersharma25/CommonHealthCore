module Api
  class SessionsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:create]

    def create

      logger.debug("From Sessions api controller the HOST IS : ************* #{request.headers["HTTP_HOST"]}")
      host = request.headers["HTTP_HOST"]

      user = User.find_by(email: params[:email])

      client_url = user.client_application.application_url

      if host == client_url
        if user&.valid_password?(params[:password])
          render json: user.as_json(only: [:email, :authentication_token,:cc, :application_representative, :pcp]),status: :created
        else
          render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
        end
      else
        render :json => {status: :unauthorized ,message: "You are not authorizes to access this applicaiton."}
      end



    end

    def destroy
      logger.debug("In the session destroy method")
    end

  end
end