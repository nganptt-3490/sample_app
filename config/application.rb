require_relative "boot"

require "rails/all"
require "mini_magick"

Bundler.require(*Rails.groups)

module RailsTutorial
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.middleware.use I18n::JS::Middleware
    config.active_storage.variant_processor = :mini_magick
  end
end
