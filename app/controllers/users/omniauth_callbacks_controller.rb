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
        @userURL = @user.client_application.application_url + '/chcAuthPage'
        # redirect_to 'https://dev11.resourcestack.com/chcAuthPage'
        # redirect_to @userURL
        # redirect_to @user.client_application.application_url + '/chcAuthPage'  
        if @user.client_application.application_url == 'dev7.resourcestack.com'
          
          ###
          uri = URI("https://dev11.resourcestack.com/chcAuthPage")
          header = {'Content-Type' => 'text/json'}
          parameters = {
             email: @user.email,
             tempToken: @user.tempToken

          }
          # Create the HTTP objects
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path, header)
          request.body = parameters.to_json
          # Send the request
          response = http.request(request)
          ###

          redirect_to "https://dev11.resourcestack.com/chcAuthPage"  

          ### ?email=#{@user.email}&tempToken=#{@user.tempToken}"

        elsif  @user.client_application.application_url == 'dev11.resourcestack.com'
          redirect_to "https://dev11.resourcestack.com/chcAuthPage?email=#{@user.email}&tempToken=#{@user.tempToken}"
        elsif @user.client_application.application_url == 'demo.commonhealthcore.org'
          redirect_to "https://demo.commonhealthcore.org/chcAuthPage?email=#{@user.email}&tempToken=#{@user.tempToken}"
        else
         #need to add additonal site 
         redirect_to no_url_path
        end

        
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
        #redirect_to users_sign_in_path
        redirect_to redirect_page_path
        #redirect this to a page 
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      #redirect_to users_sign_in_path
      redirect_to redirect_page_path
    end
  end
end


