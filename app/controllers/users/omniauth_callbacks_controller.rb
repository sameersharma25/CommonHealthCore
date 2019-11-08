class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

require 'net/http'
require 'uri'
require 'json'
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    if !@user.nil?
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        #sign_in_and_redirect @user, :event => :authentication
        response.headers["Content-Type"] = "application/json"
        response.headers["email"] = @user.email
        #response.headers["user-token"] = @user.tempToken
        userURL = user.ClientApplication.application_url + '/chcAuthPage' 
        redirect_to userURL 

=begin
           uri = URI("https://dev11.resourcestack.com/backend/api/sessions")

           header = {'Content-Type' => 'application/json'}
            user = { 
                email: @user.email,
                authentication_token: @user.authentication_token,
                google_oauth: true,
            }

           # Create the HTTP objects
           http = Net::HTTP.new(uri.host, uri.port)
           puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
           http.use_ssl = true
           request = Net::HTTP::Post.new(uri.path, header)
           request.body = user.to_json

           # Send the request
           response = http.request(request)
           puts "response #{response.body}"
           puts JSON.parse(response.body)
=end
        
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


