Rails.application.routes.draw do
  resources :scraping_rules
  resources :statuses do
    collection do
      put :sort
    end
  end
  resources :roles
  resources :service_provider_details
  resources :communications
  resources :tasks
  resources :referrals
  resources :notifications
  resources :notification_rules
  resources :appointments
  resources :patients
  resources :registration_requests
  resources :client_applications
  resources :after_signup
  # resources :users
  # get 'users/index'
  #
  # get 'user/edit'
  #
  # get 'users/new'
  # get 'users/create'
  # get 'user/show'

  devise_for :users, :controllers =>{invitations: 'invitations'}
      # devise_for :users, controllers: { registrations: 'registrations'}
  root "client_applications#index"


  get "edit" => "users#edit", as: :user_edit
  get "show" => "users#show", as: :user_show
  post "update" => "users#update", as: :user_update
  get "new_user" => "users#new", as: :new_user
  post "create_user" => "users#create", as: :create_user
  post "/wizard_add_user", to: "users#wizard_add_user"

  get "/all_details", to: "client_applications#all_details"
  get "/save_all_details", to: "client_applications#save_all_details"
  post "/copy_default_settings", to: "client_applications#copy_default_settings"
  post "send_application_invitation", to: "client_applications#send_application_invitation"
  get "/contact_management_details", to: "client_applications#contact_management"
  get "/plugin_page", to: "client_applications#plugin"
  get "/download_plugin", to: "client_applications#download_plugin"
  post "/get_contact_management", to: "client_applications#get_contact_management"

  post "internal_extrnal_storage", to: "service_provider_details#internal_extrnal_storage"
  post "filter_field_values", to: "service_provider_details#filter_field_values"
  post "/add_filter_fields", to: "service_provider_details#add_filter_fields"
  get "/filter_page", to: "service_provider_details#filter_page"


  post "/wizard_add_status", to: "statuses#wizard_add_status"


  post "/manage_scraping_rules", to: "scraping_rules#manage_scraping_rules"
  post "/validate_cat_entry", to: "scraping_rules#validate_catalogue_entries"
  post "/remove_cat_entry", to: "scraping_rules#remove_catalogue_entries"


  post "/wizard_add_notification", to: "notification_rules#wizard_add_notification"



  post "/wizard_add_new_role", to: "roles#wizard_add_new_role"
  namespace :api do
    # match 'activation', :to => 'minors#activation', via: [:get, :post]
    # post 'generate_end_point', to: 'minors#generate_end_point'
    post 'get_all_users', to: "users#get_all_users"
    post 'create_appointment', to: "users#create_appointment"
    post 'edit_appointment', to: "users#edit_appointment"
    post 'update_appointment', to: "users#update_appointment"
    post 'get_user_appointments', to: "users#get_user_appointments"
    post 'appointments_referred_to_me', to: "users#appointments_referred_to_me"
    post 'give_appointment_details_for_notification', to: "users#give_appointment_details_for_notification"
    post 'create_user', to: "users#create_user"
    post 'patients_list', to: "users#patients_list"
    post 'patient_details', to: "users#patient_details"
    post 'patient_appointments', to: "users#patient_appointments"

    post 'update_patient', to: "patients#update_patient"
    post 'create_patient', to: "patients#create_patient"
    post 'crete_appointment_for_patient', to: "patients#crete_appointment_for_patient"
    post "note_create", to: "patients#create_note"
    post "notes_list", to: "patients#patient_notes_list"

    post 'update_notifications', to: "users#update_notifications"
    resource :sessions, only: [:create, :destroy]
    resource :invitations, only: [:update]
    post 'user_accept_invitation', to: "users#set_password"
    post "password", to: "invitations#password"

    post "rfl_create", to: "referrals#create_referral"#, :as => "rfl_create"
    post "rfl_list", to: "referrals#referral_list"
    post "rfl_update", to: "referrals#update_referral"
    post "rfl_get", to: "referrals#get_referral"
    post "rfl_dashboard", to: "referrals#dashboard_referrals"
    post "patient_document", to: "referrals#patient_document"

    post "tsk_list", to: "referrals#task_list"
    post "tsk_create", to: "referrals#create_task"
    post "tsk_update", to: "referrals#update_task"
    post "tsk_get", to: "referrals#get_task"
    post "tsk_status", to: "referrals#get_task_status"
    post "tsk_dashboard", to: "referrals#dashboard_tasks"

    post "msg_send", to: "communications#send_message"
    post "msg_get", to: "communications#get_messages"
    post "msg_list", to: "communications#message_list"
    post "msg_tsk_list", to: "communications#task_message_list"
    post "msg_dashboard", to: "communications#dashboard_messages"

    post "dashboard_notifications", to: "communications#dashboard_notifications"

    #API's for Service Provider Details
    post "spd_create", to: "service_provider_details#create_provider"
    post "spd_edit", to: "service_provider_details#edit_provider_details"
    post "spd_filter", to: "service_provider_details#filter_provider"
    post "/scrappy_response", to: "service_provider_details#scrappy_doo_response"
    post "/authenticate_email", to: "service_provider_details#authenticate_user_email"

  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
