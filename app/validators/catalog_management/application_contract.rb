require 'i18n'

module CatalogManagement
  class ApplicationContract < Dry::Validation::Contract
    config.messages.backend = :i18n
    config.messages.top_namespace = "dry_validation"
    config.messages.load_paths += Dir[
      Rails.root.join('config', 'locales', 'dry_validation.*.yml')
    ]
  end
end