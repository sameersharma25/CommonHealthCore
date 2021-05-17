require 'net/http'
require 'uri'
require 'json'

class ScrapingRule
  include Mongoid::Document
  include Mongoid::Timestamps

  # field :organizationName_Text, type: String
  # field :organizationName_URL, type: String
  # field :organizationName_xpath, type: String
  field :organizationName_changeeee, type: Boolean, default: false
  # field :organizationDescription_Text, type: String
  # field :organizationDescription_URL, type: String
  # field :organizationDescription_xpath, type: String
  field :organizationDescription_changeeee, type: Boolean, default: false
  field :url_changeeee, type: Boolean, default: false
  field :organizationName, type: Hash
  field :organizationDescription, type: Hash
  field :url, type: String
  field :geoScope, type: Hash
  field :programDetails, type: Array
  field :siteDetails, type: Array
  field :changed_fields, type: Array



  def self.send_scrapping_rules
    # sr_all = ScrapingRule.all

      # sr_all.each do |sr|
    #   rule_id = sr.id.to_s
    #   organizationName_Text = sr.organizationName_Text
    #   organizationName_URL = sr.organizationName_URL
    #   organizationName_xpath = sr.organizationName_xpath
    #   organizationDescription_Text = sr.organizationDescription_Text
    #   organizationDescription_URL = sr.organizationDescription_URL
    #   organizationDescription_xpath = sr.organizationDescription_xpath
    #
    #   sr_hash = {rule_id: rule_id, OrganizationName_Text: organizationName_Text , OrganizationName_URL: organizationName_URL, OrganizationName_xpath: organizationName_xpath,
    #              OrganizationDescription_Text: organizationDescription_Text, OrganizationDescription_URL: organizationDescription_URL,
    #              OrganizationDescription_xpath: organizationDescription_xpath}
    #
    #   # sr_hash = {rule_id: rule_id, OrganizationName_Text: "This should fail" , OrganizationName_URL: "https://diamondphysicians.com/", OrganizationName_xpath: "h1",
    #   #                       OrganizationDescription_Text: "wrong desscription", OrganizationDescription_URL: organizationDescription_URL,
    #   #                       OrganizationDescription_xpath: organizationDescription_xpath}
    #   # sr_hash = {OrganizationName_Text: organizationName_Text , OrganizationName_URL: organizationName_URL}
    #   uri = URI("https://dev4.resourcestack.com/checkRule")
    #
    #   header = {'Content-Type' => 'application/json'}
    #
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
    #   http.use_ssl = true
    #
    #   request = Net::HTTP::Post.new(uri.path, header)
    #   request.body = sr_hash.to_json
    #   puts"the request body is : #{request.body}"
    #   # Send the request
    #   response = http.request(request)
    #   puts "response #{response.body}"
    #   puts JSON.parse(response.body)
    # end
    sr_ids = ScrapingRule.all.map{|h| h.id.to_s}
    ScrapingRule.validate_scraping_rules(sr_ids)
  end

  def self.validate_scraping_rules(rule_ids)
    i = 0
    rule_ids.each do |scraping_rule_id|
      i += 1
      puts "***************** Entry number is #{i}"
      sr = ScrapingRule.find(scraping_rule_id)

      rule_id = sr.id.to_s
      # organizationName_Text = sr.organizationName_Text
      # organizationName_URL = sr.organizationName_URL
      # organizationName_xpath = sr.organizationName_xpath
      # organizationDescription_Text = sr.organizationDescription_Text
      # organizationDescription_URL = sr.organizationDescription_URL
      # organizationDescription_xpath = sr.organizationDescription_xpath
      organizationName = sr.organizationName
      organizationDescription = sr.organizationDescription

      sr_hash = {catalog: {rule_id: rule_id, OrganizationName: organizationName,OrganizationDescription: organizationDescription,
                           url: sr.url, Programs: sr.programDetails, OrgSites: sr.siteDetails }}

      sr.programDetails.each do |pd|
        sr_hash[:catalog][pd.keys[0]] = pd.values[0]
      end



      # sr_hash = {rule_id: rule_id, organizationName: organizationName,organizationDescription: organizationDescription, OrganizationName_Text: organizationName_Text , OrganizationName_URL: organizationName_URL, OrganizationName_xpath: organizationName_xpath,
      #            OrganizationDescription_Text: organizationDescription_Text, OrganizationDescription_URL: organizationDescription_URL,
      #            OrganizationDescription_xpath: organizationDescription_xpath}

      # sr_hash = {rule_id: rule_id, OrganizationName_Text: "This should fail" , OrganizationName_URL: "https://diamondphysicians.com/", OrganizationName_xpath: "h1",
      #                       OrganizationDescription_Text: "wrong desscription", OrganizationDescription_URL: organizationDescription_URL,
      #                       OrganizationDescription_xpath: organizationDescription_xpath}
      # sr_hash = {OrganizationName_Text: organizationName_Text , OrganizationName_URL: organizationName_URL}
      begin
      uri = URI("https://4625.commonhealthcore.org/checkRule")
      # uri = URI("http://localhost:3001/checkRule")
      #logger.debug("***************--------------------- ************ Sending request to scrapy ****************************")
      #uri = URI("https://dev4.resourcestack.com/checkRule")

      header = {'Content-Type' => 'application/json'}

      http = Net::HTTP.new(uri.host, uri.port)
      puts "HOST IS : #{uri.host}, PORT IS: #{uri.port}, PATH IS : #{uri.path}"
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, header)
      request.body = sr_hash.to_json
      #puts"the request body is : #{request.body}"
      # Send the request
      response = http.request(request)
      #puts "response #{response.body}"
     # puts JSON.parse(response.body)
     rescue => e
        Rails.logger.debug("*************you are in the UNKNOWN rescue block--------#{e}")
      end

    end
  end


end
