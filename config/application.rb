require_relative "boot"

require "rails/all"
require 'dotenv/load'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shoppix
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_controller.default_protect_from_forgery = true
    config.stripe = {
      secret_key: ENV['STRIPE_SECRET_KEY'],
      publishable_key: ENV['STRIPE_PUBLISHABLE_KEY']
    }
    
    config.after_initialize do
      Stripe.api_key = config.stripe[:secret_key]
    end
   
    config.before_configuration do
      env_file = File.join(Rails.root, '.env')
      if File.exist?(env_file)
        require 'dotenv'
        Dotenv.load(env_file)
      end
    end
# config/application.rb


    config.middleware.use ActionDispatch::Cookies
config.middleware.use ActionDispatch::Session::CookieStore
config.middleware.use ActionDispatch::Flash

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
