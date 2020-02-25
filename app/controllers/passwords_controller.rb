class PasswordsController < Devise::PasswordsController


  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      # respond_with resource, location: after_resetting_password_path_for(resource)
      redirect_to destroy_user_session_path
    else
      set_minimum_password_length
      respond_with resource
    end
  end


end
