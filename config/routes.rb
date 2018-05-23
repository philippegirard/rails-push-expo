Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/push/register', to: 'push#register'

  get '/push/notif', to: 'push#notif'
  get '/push/notif/:id', to: 'push#notif'
end
