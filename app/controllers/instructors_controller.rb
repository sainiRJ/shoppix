require 'bulk_sms_service' 
require 'twilio-ruby'
require_relative "../../lib/json_web_token"


class InstructorsController < ApplicationController
  skip_before_action :verify_authenticity_token, only:[:sms, :send_otp]
  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = User.new(instructor_params)
    @email = @instructor.email
    session[:instructor] = @instructor
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
    redirect_to instructor_verify_path
  end

  def postVerify
    def verify

    end
    entered_smsOTP = params[:smsOTP]
    entered_mailOTP = params[:mailOTP]
    stored_smsOTP = session[:registration_smsOTP]
    stored_mailOTP = session[:registration_mailOTP]
  instructor = Instructor.new(session[:instructor])
  if entered_smsOTP == stored_smsOTP && entered_mailOTP == stored_mailOTP
      if instructor.save
      instructor.save
      session.delete(:registration_smsOTP) 
      session.delete(:registration_mailOTP) 
      session.delete(:instructor)
      redirect_to instructor_login_path
      # render json: {message: "user saved in database"}
      # redirect_to root_path, notice: "OTP verified successfully!"
      else
        render json: { errors: instructor.errors.full_messages, status: :unprocessable_entity }
      end
    else
    #   flash.now[:alert] = "Invalid OTP. Please try again."
      render :verify
    render json: {error: "OTP is invalid"}

    end
  end

  def login
    def login_form
    end
    email = params[:email]
    password = params[:password]
    @instructor = Instructor.find_by(email: email)
    if @instructor && @instructor.authenticate(password)
    session[:id] = @instructor.id
    mailOTP = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
    session[:login_mailOTP] = mailOTP
    UserMailer.registration_otp(email,mailOTP).deliver_now
    redirect_to instructor_signup_path
      
    else
      render json: {error: "instructor does not exist"}
    end
  end

  def verified
    if session[:login_mailOTP] == params[:mailOTP]
      id = session[:id]
      payload={ instructor_id: id}
      token = ::JsonWebToken.encode(payload) 
      session[:token] = token 
      session.delete(:login_mailOTP)
      session.delete(:id)
      redirect_to course_new_path
    else
      flash.now[:alert] = "Invalid OTP. Please try again."
    render json: {error: "OTP is invalid"}
    end
  end

  def logout
    session.delete(:token)
    redirect_to instructor_login_path
  end


  def instructor_params
    params.require(:instructor).permit(:full_name, :email, :mobile_number, :password, :password_confirmation)
  end
end




