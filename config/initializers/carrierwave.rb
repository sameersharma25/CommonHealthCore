# require 'carrierwave/storage/fog'
require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      =>
      :aws_secret_access_key  =>
      :region                 => 'us-west-2' # Change this for different AWS region. Default is 'us-east-1'
  }
  # config.storage = :fog
  # config.fog_provider = 'fog/aws'
  config.fog_directory = "agreement-templates-dev"
  # config.storage = :fog
end
