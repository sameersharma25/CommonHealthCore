class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    if !@user.nil?
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        #sign_in_and_redirect @user, :event => :authentication

      
        response.headers["Content-Type"] = "application/pdf"
        response.headers["user-token"] = @user.authentication_token
        redirect_to 'https://dev11.resourcestack.com/dashboard/' 
        
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to users_sign_in_path
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to users_sign_in_path
    end
  end
end


