require 'i18n'
require 'dry-schema'

module CatalogManagement
  module ValidationTypes
    include Dry::Types()
  end

  class BaseParamValidator < Dry::Schema::Params
    define do
      config.messages.backend = :i18n
      config.messages.load_paths += Dir[
        Rails.root.join('config', 'locales', 'dry_validation.*.yml')
      ]
    end
  end
end