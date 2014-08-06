Discourse::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Don't Digest assets, makes debugging uglier
  config.assets.digest = false

  config.assets.debug = true

  config.watchable_dirs['lib'] = [:rb]

  config.sass.debug_info = false
  config.handlebars.precompile = false

  if GlobalSetting.smtp_address
    settings = {
      address:              GlobalSetting.smtp_address,
      port:                 GlobalSetting.smtp_port,
      domain:               GlobalSetting.smtp_domain,
      user_name:            GlobalSetting.smtp_user_name,
      password:             GlobalSetting.smtp_password,
      authentication:       GlobalSetting.smtp_authentication,
      enable_starttls_auto: GlobalSetting.smtp_enable_start_tls
    }

    settings[:openssl_verify_mode] = GlobalSetting.smtp_openssl_verify_mode if GlobalSetting.smtp_openssl_verify_mode

    config.action_mailer.smtp_settings = settings.reject{|x,y| y.nil?}
  else
    # we recommend you use mailcatcher https://github.com/sj26/mailcatcher
    config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  end

  config.action_mailer.raise_delivery_errors = true

  BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']

  config.load_mini_profiler = true

  require 'middleware/turbo_dev'
  require 'middleware/missing_avatars'
  config.middleware.insert 0, Middleware::TurboDev
  config.middleware.insert 1, Middleware::MissingAvatars

  config.enable_anon_caching = false
  require 'rbtrace'

  if emails = GlobalSetting.developer_emails
    config.developer_emails = emails.split(",")
  end
end
