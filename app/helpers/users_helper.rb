module UsersHelper
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
      @current_user = user
      User.current = current_user
      # sign_in user, store: false
    else
      logger.debug("In the authenticate_user_from_token INSIDE THE ELSE *************")
      # render nothing: true, status: :unauthorized and return
      # return false
      render :json => {status: :unauthorized ,message: "You have to login"}
    end
  end

  def authenticate_admin_user_from_token
    logger.debug("In the authenticate_user_from_token *************current USER IS #{@current_user.inspect}")
    if !current_user.nil?
      logger.debug("current user is present***********")
           return @current_user
    else

      user_email = params[:email].presence
      user       = user_email && User.find_by(email: user_email)

      user_token =  params["user-token"]
      # user_token =  "kstxUxK2qfBAqbfcvAef"

      logger.debug("In the authenticate_user_from_token USER IS: #{user.inspect} ************* HEADER IS: #{user_token}")
      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      if user && Devise.secure_compare(user.authentication_token, user_token)
        logger.debug("In the authenticate_user_from_token INSIDE THE IF *************")
        @current_user = user
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
