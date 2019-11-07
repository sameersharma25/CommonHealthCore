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

#we could just make a post method to dev11 which would accept a user email and user.authtoken.
#security issue 



#each site will have a unique post to dev7. (recreating oauth). This will redirect them to dev7 and trigger google oAuth


  #dev11POST dev11.commonhealthcore.com {userEmail: '', originURL: 'dev11.resourcestack.com', securityCode: 'randomHexGeneratedByDev7'}
  #if user is a user of Dev7 && originURL exists && securityCode matches 
  #google Oauth will complete it's course. The originURL will be used to trigger a redirect from OmniAuthController 
    #respond back to dev11 with #redirect_to dev7 oAuth

#Dev11 authPage will make a login request

#if the login request is valid, dev7 authenticates the login process



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


