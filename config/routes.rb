Rails.application.routes.draw do
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

  namespace :api do
    # match 'activation', :to => 'minors#activation', via: [:get, :post]
    # post 'generate_end_point', to: 'minors#generate_end_point'
    post 'get_all_users', to: "users#get_all_users"
    post 'create_appointment', to: "users#create_appointment"
    post 'edit_appointment', to: "users#edit_appointment"
    post 'update_appointment', to: "users#update_appointment"
    post 'get_user_appointments', to: "users#get_user_appointments"
    post 'appointments_referred_to_me', to: "users#appointments_referred_to_me"
    post 'create_user', to: "users#create_user"
    resource :sessions, only: [:create, :destroy]
  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
