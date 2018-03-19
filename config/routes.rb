Rails.application.routes.draw do
  resources :client_applications
  get 'users/index'

  # get 'users/edit'

  get 'users/new'
  # get 'users/show'

  devise_for :users

  root "client_applications#index"


  get "edit" => "users#edit", as: :user_edit
  get "show" => "users#show", as: :user_show

  namespace :api do
    # get 'activation', to: 'minors#activation'
    match 'activation', :to => 'minors#activation', via: [:get, :post]
    post 'generate_end_point', to: 'minors#generate_end_point'
    post 'user_find', to: "users#user_find"
  end
  # patch "update" => "users#update", as: :user_update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
