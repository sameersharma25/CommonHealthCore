Rails.application.routes.draw do
  # apipie
  resources :terms_privacies
  resources :about_us
  resources :faqs
  resources :show_templates
  resources :baa_language_segments
  resources :questions
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
    mount Ckeditor::Engine => '/ckeditor'
  resources :after_signup
  resources :after_signup_external
  resource :two_factor
  

  # resources :users
  # get 'users/index'
  #
  # get 'user/edit'
  #
  # get 'users/new'
  # get 'users/create'
  # get 'user/show'

  #devise_for :users, :controllers =>{invitations: 'invitations'}
  # devise_for :users, controllers: { registrations: 'registrations'}



  devise_for :users, :controllers =>{invitations: 'invitations', sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks',
                                     passwords: 'passwords' }
      devise_scope :user do
        apipie
        scope :users, as: :users do

          post 'pre_otp', to: 'users/sessions#pre_otp' 
        end 
      end 
  
  root "client_applications#index"

  get "edit" => "users#edit", as: :user_edit
  get "show" => "users#show", as: :user_show
  post "update" => "users#update", as: :user_update
  get "new_user" => "users#new", as: :new_user
  post "create_user" => "users#create", as: :create_user
  post "/wizard_add_user", to: "users#wizard_add_user"
  post "/check_user_role", to: "users#check_user_role"

  get "/all_details", to: "client_applications#all_details"
  post "/save_all_details", to: "client_applications#save_all_details"
  post "/copy_default_settings", to: "client_applications#copy_default_settings"
  post "send_application_invitation", to: "client_applications#send_application_invitation"
  post "send_application_prep_request", to: "client_applications#send_application_prep_request"
  get "/contact_management_details", to: "client_applications#contact_management"
  get "/invalid_contact_management_details", to: "client_applications#invalid_catalog_management"
  get "/master_provider", to: "client_applications#master_provider"
  get "/plugin_page", to: "client_applications#plugin"
  get "/pending_agreements", to: "client_applications#pending_agreements"
  post "/counter_sign_popup", to: "client_applications#counter_sign_popup"
  post "/upload_countersign_doc", to: "client_applications#upload_countersign_doc"
  post "/reject_agreement_template", to: "client_applications#reject_agreement_template"
  get "/fhir_response", to: "client_applications#fhir_response"

  post "/define_parameters", to: "client_applications#define_parameters"
  post "/external_api_setup", to: "client_applications#external_api_setup"
  post "/parameters_mapping", to: "client_applications#parameters_mapping"

  get "/download_plugin", to: "client_applications#download_plugin"
  match "/catalogMangViewer" => "client_applications#catalogMangViewer", via: [:get, :post]
  match "/new_site_adding" => "client_applications#new_site_adding", via: [:get, :post]

  # match "user/account" => "user#account", as: :user_account, via: [:get, :post]
  post "/get_contact_management", to: "client_applications#get_contact_management"
  post "/master_provider_details", to: "client_applications#master_provider_details"

  get "/get_patients", to: "client_applications#get_patients"
  post "/send_task", to: "client_applications#send_task"
  post "/check_duplicates", to: "client_applications#check_duplicate_entries"
  post "/duplicate_entry_details", to: "client_applications#duplicate_entry_details"

  get "/agreement_management", to: "client_applications#agreement_management"
  get "/add_agreement_template", to: "client_applications#add_agreement_template"
  post "/create_agreement_template", to: "client_applications#create_agreement_template"
  post "/change_status_of_agreement_template", to: "client_applications#change_status_of_agreement_template"
  get "/question_sequence", to: "client_applications#question_sequence"
  post "/update_sequence", to: "client_applications#update_sequence"
  get "/sample_page", to: "client_applications#sample_page"

  ###THINGS THAT MASON ADDED
  post "send_for_approval", to: "client_applications#send_for_approval"
  post "reject_catalog", to: "client_applications#reject_catalog"
  post "delete_catalog", to: "client_applications#delete_catalog"
  post "approve_catalog", to: "client_applications#approve_catalog"

  get "about_us_page", to: "static_pages#about"
  get "faq_page", to: "static_pages#faq"
  get "admin_contact", to: "static_pages#admin_contact"
  get "redirect_page", to: "static_pages#redirect_page"
  get "no_url", to: "static_pages#no_url"

  get "/reset_password", to: "reset_password#reset_password"
  post "/reset_password_part_two", to: "reset_password#reset_password_part_two" 
  ### End mason

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

  get "/security_keys", to: "security_keys#index"
  post '/security_keys', to: 'security_keys#create' 
  post '/delete_keys', to: 'security_keys#delete' 
  post '/update_keys', to: 'security_keys#update' 

  post "/save_question_response", to: "question_response#save_question_response"
  get "/question_form", to: "question_response#question_form"
  post "/next_question", to: "question_response#next_question"
  post "/skip_survey", to: "question_response#skip_survey"

  get "pg_filter", to: "client_applications#pg_filter"
  post "/filtered_list", to: "client_applications#filtered_list"
  #post "/see_pg_entry", to: "client_applications#see_pg_entry"
  match "/see_pg_entry" => "client_applications#see_pg_entry", via: [:get, :post]


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

    post 'patient_appointments', to: "users#patient_appointments"

    post 'get_faq', to: "users#get_faq"
    post 'get_about_us', to: "users#get_about_us"
    post 'get_terms', to: "users#get_terms"
    post 'get_logo', to: "users#get_logo"
    post 'change_user_password', to: 'users#change_user_password'
    post 'get_theme', to: 'users#get_theme'
    post 'set_theme', to: 'users#set_theme'
    get 'admin_details', to: 'users#admin_details'
    post 'user_profile', to: 'users#user_profile'
    post 'edit_profile', to: 'users#edit_profile'
    post 'app_version', to: "users#app_version"
    post 'forgot_password', to: "users#forgot_password"
    

    post 'chcAuthentication', to: 'users#chcAuthentication' 



    post 'update_patient', to: "patients#update_patient"
    post 'create_patient', to: "patients#create_patient"
    post 'crete_appointment_for_patient', to: "patients#crete_appointment_for_patient"
    post "note_create", to: "patients#create_note"
    post "notes_list", to: "patients#patient_notes_list"
    post "med_patient", to: "patients#med_patient"
    post 'patient_details', to: "patients#patient_details"
    post 'patients_list', to: "patients#patients_list"

    post 'update_notifications', to: "users#update_notifications"
    resource :sessions, only: [:create, :destroy, :verify]
    post 'verify', to: "sessions#verify"
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
    post "rfl_assessments", to: "referrals#referral_assessments"
    post "org_invite", to: "referrals#invite_org"


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

    post "/create_catalog", to: "service_provider_details#create_catalog_entry"
    post "/update_catalog", to: "service_provider_details#update_catalog_entry"
    post "/update_entire_catalog", to: "service_provider_details#update_entire_catalog"
    
    post "/update_pg_catalog_entry", to: "service_provider_details#update_pg_catalog_entry"

    post "/advanced_search", to: "service_provider_details#advanced_search"
    post "/service_group_list", to: "service_provider_details#service_group_list"
    post "/population_group_list", to: "service_provider_details#population_group_list"
    post "/service_tag_list", to: "service_provider_details#service_tag_list"
    post "/favorite_query_list", to: "service_provider_details#favorite_query_list"
    post "/delete_favorite_query", to: "service_provider_details#delete_favorite_query"

    post "/site_update", to: "service_provider_details#site_update"
    post "/site_program_list",to: "service_provider_details#site_program_list"

    # post "/program_list", to: "service_provider_details#catalogue_program_list"

    post "/get_site_by_id", to: "service_provider_details#get_catalogue_site_by_id"
    post "/get_program_by_id", to: "service_provider_details#get_catalogue_program_by_id"
    post "/program_update", to: "service_provider_details#program_update"
    post "/invite_new_provider", to: "service_provider_details#invite_new_provider"

    #API's for External Application
    post "/send_patient", to: "external_applications#send_patient"
    post "/reject_request", to: "external_applications#reject_request"
    get "/client_list", to: "external_applications#client_list"
    post "rfl_send", to: "external_applications#send_referral"
    post "rfl_out", to: "external_applications#out_going_referrals"
    post "rfl_in", to: "external_applications#in_coming_referrals"
    post "tsk_changes", to: "external_applications#new_ledger_record"
    post "/ledg_details", to: "external_applications#ledger_details"
    post "/revert_request", to: "external_applications#revert_request"

    get "receive_fhir_patient", to: "external_applications#receive_fhir_patient"

    #API's for Interview
    post "/int_create", to: "interviews#new_interview"
    post "/int_update", to: "interviews#update_interview"
    post "/int_list", to: "interviews#interview_list"
    post "/int_details", to: "interviews#interview_details"
    post "/int_details_test", to: "interviews#interview_details_test"
    post "/active_needs", to: "interviews#active_needs"

    post "/need_create", to: "interviews#new_need"
    post "/need_update", to: "interviews#update_need"
    post "/need_remove", to: "interviews#remove_need"


    post "/obstacle_create", to: "interviews#new_obstacle"
    post "/obstacle_update", to: "interviews#update_obstacle"
    post "/obstacle_remove", to: "interviews#remove_obstacle"

    post "/sol_create", to: "interviews#new_solution"
    post "/sol_update", to: "interviews#update_solution"
    post "/sol_remove", to: "interviews#remove_solution"

    post "/clients_created_by_a_navigator", to: "reports#clients_created_by_a_navigator"
    post "/assessment_created_by_a_navigator", to: "reports#assessment_created_by_a_navigator"
    post "/task_transferred_by_navigator", to: "reports#task_transferred_by_navigator"
    post "/requests_accepted_by_navigator", to: "reports#requests_accepted_by_navigator"
    post "/requests_rejected_by_navigator", to: "reports#requests_rejected_by_navigator"
    post "/customers_referred_by_navigator", to: "reports#organizations_referred_by_my_organization"
    post "/customers_referred_to_navigator", to: "reports#organizations_referred_to_my_organization"


  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
