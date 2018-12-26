# require 'app/uploaders/provider_data_file_uploader'
require 'carrierwave/mongoid'
require 'csv'
require 'net/http'
require 'uri'
require 'json'

class ServiceProviderDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :service_provider_name, type: String
  field :provider_type, type: String
  field :share, type: Boolean
  field :data_storage_type, type: String
  field :service_provider_api, type: String
  field :filtering_fields, type: Hash
  field :coordinates_provided, type: Boolean
  field :lat_name, type: String
  field :long_name, type: String
  field :data_loaded, type: Boolean, default: false
  mount_uploader :provider_data_file, ProviderDataFileUploader

  belongs_to :client_application

  validates :service_provider_name, presence: true
  validates :data_storage_type , presence: true



  def self.populate_service_provider_data
    provoders = ServiceProviderDetail.where(data_storage_type: "Internal")

    provoders.each do |p|
      puts("the provider is #{p.inspect}-----------#{p.provider_data_file.present?}")
      if (p.data_loaded == false && p.provider_data_file.present?)
        # csv = CSV::parse(File.open("/Users/harshavardhangandhari/RSI/chc/public/#{ServiceProviderDetail.find_by(service_provider_name: 'fbsdfd').provider_data_file.url}") {|f| f.read })
        if "/public/#{p.provider_data_file.url}"
        csv = CSV::parse(File.open("/Users/harshavardhangandhari/RSI/chc/public/#{p.provider_data_file.url}") {|f| f.read })
        fields = csv.shift
        fields = fields.map {|f| f.gsub(" ", "_")}

        # logger.debug("********** the fields are: #{fields} ")
        i = 1
        @db_data = csv.collect do |record|
          record.insert(24, i)
          i += 1
          # logger.debug("recorn is : #{record}")
          r =  Hash[*fields.zip(record).flatten ]
          r["service_provider"] = p.service_provider_name
          r
        end
        dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
        table_name = 'chc_provider'

        @db_data.each{|sp|
          params = {
              table_name: table_name,
              item: sp
          }
          begin
            result = dynamodb.put_item(params)
            # puts "Added movie: #{movie["year"]} #{movie["title"]}"
            puts "Addes SP: #{sp["Name"]} ******* #{i}"
            i += 1
          rescue  Aws::DynamoDB::Errors::ServiceError => error
            puts "Unable to add SP:"
            puts "#{error.message}"
          end
        }

          p.data_loaded = true
          p.save
        end
      end
    end
  end

end
