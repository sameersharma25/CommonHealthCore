module Api
  class UsersController < ActionController::Base

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
  end
end