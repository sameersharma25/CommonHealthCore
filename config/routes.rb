Rails.application.routes.draw do
  resources :appointments
  resources :patients
  resources :registration_requests
  resources :client_applications
  # resources :users
  # get 'users/index'
  #
  # get 'user/edit'
  #
  # get 'users/new'
  # get 'users/create'
  # get 'user/show'

  devise_for :users
  # devise_for :users, controllers: { registrations: 'registrations'}
  root "client_applications#index"


  get "edit" => "users#edit", as: :user_edit
  get "show" => "users#show", as: :user_show

  namespace :api do
    # match 'activation', :to => 'minors#activation', via: [:get, :post]
    post 'generate_end_point', to: 'minors#generate_end_point'
    post 'user_find', to: "users#user_find"
    post 'create_appointment', to: "users#create_appointment"
    post 'get_user_appointments', to: "users#get_user_appointments"
    resource :sessions, only: [:create, :destroy]
  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
