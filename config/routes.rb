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
  resources :after_signup_external
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

  post "/define_parameters", to: "client_applications#define_parameters"
  post "/external_api_setup", to: "client_applications#external_api_setup"
  post "/parameters_mapping", to: "client_applications#parameters_mapping"

  get "/download_plugin", to: "client_applications#download_plugin"
  post "/get_contact_management", to: "client_applications#get_contact_management"

  get "/get_patients", to: "client_applications#get_patients"
  post "/send_task", to: "client_applications#send_task"

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

  post "/after_signup_external/api_setup", to: "after_signup_external#update"

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
    post "med_patient", to: "patients#med_patient"

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
    post "ledg_rec_create", to: "referrals#create_ledger_record"
    post "ext_app_ledger", to: "referrals#ext_app_ledger"


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
    post "/get_catalogue_entry", to: "service_provider_details#contact_management_details_for_plugin"

    post "/site_update", to: "service_provider_details#site_update"
    post "/site_program_list",to: "service_provider_details#site_program_list"

    # post "/program_list", to: "service_provider_details#catalogue_program_list"

    post "/get_site_by_id", to: "service_provider_details#get_catalogue_site_by_id"
    post "/get_program_by_id", to: "service_provider_details#get_catalogue_program_by_id"
    post "/program_update", to: "service_provider_details#program_update"

    #API's for External Application
    post "/send_patient", to: "external_applications#send_patient"
    get "/client_list", to: "external_applications#client_list"
    post "rfl_send", to: "external_applications#send_referral"
    post "rfl_out", to: "external_applications#out_going_referrals"
    post "rfl_in", to: "external_applications#in_coming_referrals"
    post "tsk_changes", to: "external_applications#new_ledger_record"

    #API's for Interview
    post "/int_create", to: "interviews#new_interview"
    post "/int_update", to: "interviews#update_interview"
    post "/int_list", to: "interviews#interview_list"
    post "/int_details", to: "interviews#interview_details"

    post "/need_create", to: "interviews#new_need"
    post "/need_update", to: "interviews#update_need"
    post "/need_remove", to: "interviews#remove_need"


    post "/obstacle_create", to: "interviews#new_obstacle"
    post "/obstacle_update", to: "interviews#update_obstacle"
    post "/obstacle_remove", to: "interviews#remove_obstacle"

    post "/sol_create", to: "interviews#new_solution"
    post "/sol_update", to: "interviews#update_soulution"
    post "/sol_remove", to: "interviews#remove_solution"



  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
