class SessionsController < ApplicationController
    def google_login
      auth = request.env['omniauth.auth']
      user = User.from_google_omniauth(auth)
      
      if user
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully with Google'
      else
        redirect_to root_path, alert: 'Google login failed'
      end
    end
  end
  