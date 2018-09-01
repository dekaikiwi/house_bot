Rails.application.routes.draw do
  resources :line_groups
  resources :line_users
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/webhooks/line', to: 'webhooks#line'
end
