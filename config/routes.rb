Rails.application.routes.draw do
  resources :courses, only: [:index, :show]

  get 'user/register', to: 'users#new'
  post 'user/register', to: 'users#create'
  get 'instructor/register', to: 'instructors#new'
  post 'instructor/register', to: 'instructors#create'
  get 'user/verify', to: 'users#verify'
  post 'user/verify', to: 'users#postVerify'  
  get 'instructor/verify', to: 'instructors#verify'
  post 'instructor/verify', to: 'instructors#postVerify'  
  post 'sms', to: 'users#sms'
  post 'send_otp', to: 'users#send_otp'
  get '/auth/auth0', to: 'users#google_oauth2'
  get '/auth/auth0/callback', to: 'users#google_oauth2'
  get '/user/login', to: 'users#login_form' 
  post '/user/login', to: 'users#login'
  get '/user/signup', to: 'users#signup'
  post '/user/signup', to: 'users#verified'
  get '/instructor/login', to: 'instructors#login_form' 
  post '/instructor/login', to: 'instructors#login'
  get '/instructor/signup', to: 'instructors#signup'
  post '/instructor/signup', to: 'instructors#verified'
  post '/logout', to: 'instructor#logout'
  get '/course/new', to: 'courses#new'
  post '/course/create', to: 'courses#create'
  get '/content/new', to: 'courses_contents#new'
  post '/content/create', to: 'courses_contents#create'
  get '/course/show/:id', to: 'courses#show'
  get '/course/index', to: 'courses#index'
  post '/course/payment', to: 'payments#create'

end
