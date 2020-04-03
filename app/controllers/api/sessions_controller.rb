module Api
  class SessionsController < ActionController::Base
    include UsersHelper
    before_action :authenticate_user_from_token, except: [:create, :verify]
    after_create :clear_otp

    def verify
        my_user = User.find_by(email: params[:email])
        otp_required = my_user.otp_required_for_login
        my_user.active_otp = current_otp(my_user)
        my_user.save!
        
        if otp_required == true
        #if active_otp == true
          #mail/text the OTP
          @otp_is = current_otp(my_user)
          logger.debug("EMAIL/TEXT THIS VALUE::: #{@otp_is}")
          TwoFactorMailer.sendOTP(@otp_is, my_user.email).deliver
          render :json => {staus: :ok, two_factor_enabled: otp_required, message: 'Please check your email for your one time password.' }
        else
          render :json => {status: :ok, two_factor_enabled: otp_required} 
        end 

    end 

    def create 

      logger.debug("From Sessions api controller the HOST IS : ************* #{request.headers["HTTP_HOST"]}")
      host = request.headers["HTTP_HOST"]
      user = User.find_by(email: params[:email])
      client_url = user.client_application.application_url
      otp_required = user.otp_required_for_login
      
      if user.active == true
        if otp_required == true # check the otp_attemp
        #if active_otp == true

            if params[:otp_attempt] == user.active_otp
                logger.debug("Allow the user to login")
                # if host == client_url
                  if user&.valid_password?(params[:password])
                    render json: user.as_json(only: [:email, :authentication_token,:cc, :application_representative, :pcp]),status: :created
                  else
                    render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
                  end
                # else
                #   render :json => {status: :unauthorized ,message: "You are not authorizes to access this applicaiton."}
                # end

            else
              logger.debug("Something went wrong ")
              #Dont Allow the user to login
              render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
            end
        else
            #catch the request from Wordpress HERE

            # if host == client_url
              if user&.valid_password?(params[:password])
                render json: user.as_json(only: [:email, :authentication_token,:cc, :application_representative, :pcp]),status: :created
              elsif params[:googleOauthLogin] == 'true' && params[:tempToken] == user.tempToken
                  user.tempToken = ''
                  user.save

                  render json: user.as_json(only: [:email, :authentication_token,:cc, :application_representative, :pcp]),status: :created
              else
                render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
              end
            # else
            #   render :json => {status: :unauthorized ,message: "You are not authorizes to access this applicaiton."}
            # end
        end
      else
        render :json => {status: :unauthorized ,message: "This user is deactivatted, please contact the admin to activate the user."}
      end




    end

    def clear_otp
      user = User.find_by(email: params[:email])
      user.active_otp = ""
      user.save!
    end

    def destroy
      logger.debug("In the session destroy method")
    end

    private 

    def current_otp(user)
      return user.current_otp

    end 

  end 
end