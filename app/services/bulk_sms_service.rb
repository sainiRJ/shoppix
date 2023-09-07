class BulkSmsService
    include HTTParty
    base_uri 'https://www.bulksms.com/eapi/'
  
    def initialize
      @username = BULKSMS_USERNAME
      @password = BULKSMS_PASSWORD
    end
  
    def send_otp(phone_number, otp)
      response = self.class.get(
        '/send_message/2/2.0',
        query: {
          username: @username,
          password: @password,
          message: "Your OTP is #{otp}",
          msisdn: phone_number
        }
      )
  
      if response.code == 200 && response.parsed_response['error'] == '0'
        # Message sent successfully
        return true
      else
        # Handle the error (e.g., log it or raise an exception)
        Rails.logger.error("Failed to send OTP: #{response.parsed_response['error_description']}")
        return false
      end
    end
  end
  