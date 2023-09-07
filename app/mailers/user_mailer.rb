class UserMailer < ApplicationMailer
    def registration_otp(email, otp)
      email = email
      @otp = otp
      mail(to: email, subject: 'Registration OTP')
    end
  end
  