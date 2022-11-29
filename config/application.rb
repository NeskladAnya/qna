require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    config.active_storage.replace_on_assign_to_many = false

    config.action_cable.disable_request_forgery_protection = false

    config.autoload_paths += [config.root.join('app/services')]
    
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       routing_specs: false,
                       helper_specs: false,
                       request_specs: false,
                       controller_specs: true
    end

    config.cache_store = :redis_store, 'redis://localhost:6319/0/cache', { expires_in: 90.minutes }
  end
end
