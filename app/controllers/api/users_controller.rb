module Api
  class UsersController < ActionController::Base
    before_action :authenticate_user_from_token

    def user_find
      logger.debug("the user email you sent is : #{params[:email]}")
      user = User.find_by(email: params[:email])

      render :json=> {status: :ok,message: "Login Successful",
                      data: {:user_id=>user.id.to_s, :name => user.name, :cc => user.cc, admin: user.admin, pcp: user.pcp }}

      # resource = User.find_for_database_authentication(:email=>params[:email])
      # return invalid_login_attempt unless resource

      # if resource.valid_password?(params[:password])
      #   # sign_in("user", resource)
      #   user = User.find_by_email(params[:email])
      #   render :json=> {status: :ok,message: "Login Successful", data: {:user_id=>user.id.to_s, :auth_token => user.api_token}}
      #   return
      # end

    end

    private

    def authenticate_user_from_token
      logger.debug("In the authenticate_user_from_token *************")
      user_email = params[:email].presence
      user       = user_email && User.find_by(email: user_email)

      user_token = request.headers["HTTP_USER_TOKEN"]
      logger.debug("In the authenticate_user_from_token USER IS: #{user.inspect} ************* HEADER IS: #{user_token}")
      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      if user && Devise.secure_compare(user.authentication_token, user_token)
        logger.debug("In the authenticate_user_from_token INSIDE THE IF *************")
        # sign_in user, store: false
      else
        logger.debug("In the authenticate_user_from_token INSIDE THE ELSE *************")
        # render nothing: true, status: :unauthorized and return
        # return false
        render :json => {status: :unauthorized ,message: "You have to login"}
      end
    end

  end
end