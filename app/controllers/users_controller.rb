require 'bulk_sms_service' 
require 'twilio-ruby'
require_relative "../../lib/json_web_token"


class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token, only:[:sms, :send_otp, :google_oauth2]
  skip_before_action :verify_authenticity_token, only: [:google_oauth2]
  protect_from_forgery with: :exception
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @email = @user.email
    session[:user] = @user
    mailOTP = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
    smsOTP = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    message = @client.messages
   .create(
        from: '+15673611296',
        body: "your 2-step Verification OTP is #{smsOTP}",
        to: '+917310156773'
      )
    session[:registration_mailOTP] = mailOTP
    session[:registration_smsOTP] = smsOTP
    UserMailer.registration_otp(@email,mailOTP).deliver_now
    redirect_to user_verify_path
  end

  def google_oauth2
    auth = request.env['omniauth.auth']
    puts  puts "Auth Data: #{auth.inspect}"
    user_info = auth.info
    user = User.find_or_initialize_by(email: user_info.email)
    user.uid = auth.uid
    user.name = user_info.name
    user.email = user_info.email
    user.password = Devise.friendly_token[0, 20]

    if user.save
      redirect_to root_url, notice: 'Logged in successfully'
    else
      redirect_to login_url, alert: 'Error creating user'
    end
  end


  def postVerify
    def verify

    end
    entered_smsOTP = params[:smsOTP]
    entered_mailOTP = params[:mailOTP]
    stored_smsOTP = session[:registration_smsOTP]
    stored_mailOTP = session[:registration_mailOTP]
    user = User.new(session[:user])
    if entered_smsOTP == stored_smsOTP && entered_mailOTP == stored_mailOTP
      if user.save
      user.save
      session.delete(:registration_smsOTP) 
      session.delete(:registration_mailOTP) 
      session.delete(:user)
      render json: {message: "user saved in database"}
      # redirect_to root_path, notice: "OTP verified successfully!"
      else
        render json: { errors: user.errors.full_messages, status: :unprocessable_entity }
      end
    else
      flash.now[:alert] = "Invalid OTP. Please try again."
    render json: {error: "OTP is invalid"}

    end
  end

  def login
    def login_form
    end
    email = params[:email]
    password = params[:password]
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
    mailOTP = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
    session[:login_mailOTP] = mailOTP
    UserMailer.registration_otp(email,mailOTP).deliver_now
    redirect_to user_signup_path
      
    else
      render json: {error: "user does not exist"}
    end
  end

  def verified
    if session[:login_mailOTP] == params[:mailOTP]
      session.delete(:login_mailOTP)
      render json: {message: "login successfully"}
    else
      flash.now[:alert] = "Invalid OTP. Please try again."
    render json: {error: "OTP is invalid"}
    end
  end



  def user_params
    params.require(:user).permit(:full_name, :email, :mobile_number, :password, :password_confirmation)
  end
end



