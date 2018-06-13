Rails.application.routes.draw do
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

  get "/all_details", to: "client_applications#all_details"
  get "/save_all_details", to: "client_applications#save_all_details"

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
    post 'update_notifications', to: "users#update_notifications"
    resource :sessions, only: [:create, :destroy]
  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
