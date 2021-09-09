require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShoppingTroll
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

    # Disable the .field_with_errors wrapper and add .is-invalid class
    # for Bootstrap validations to work properly
    config.action_view.field_error_proc = proc do |html_tag, instance|
      html_tag.gsub("form-control", "form-control is-invalid").html_safe
    end
  end
end
