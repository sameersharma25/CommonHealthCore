class ScrapingRulesController < ApplicationController
  before_action :set_scraping_rule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:manage_scraping_rules]
  skip_before_action :verify_authenticity_token, only: [:manage_scraping_rules]

  # GET /scraping_rules
  # GET /scraping_rules.json
  def index
    @scraping_rules = ScrapingRule.all
  end

  # GET /scraping_rules/1
  # GET /scraping_rules/1.json
  def show
  end

  # GET /scraping_rules/new
  def new
    @scraping_rule = ScrapingRule.new
  end

  # GET /scraping_rules/1/edit
  def edit
  end

  # POST /scraping_rules
  # POST /scraping_rules.json
  def create
    @scraping_rule = ScrapingRule.new(scraping_rule_params)

    respond_to do |format|
      if @scraping_rule.save
        format.html { redirect_to @scraping_rule, notice: 'Scraping rule was successfully created.' }
        format.json { render :show, status: :created, location: @scraping_rule }
      else
        format.html { render :new }
        format.json { render json: @scraping_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scraping_rules/1
  # PATCH/PUT /scraping_rules/1.json
  def update
    respond_to do |format|
      if @scraping_rule.update(scraping_rule_params)
        format.html { redirect_to @scraping_rule, notice: 'Scraping rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @scraping_rule }
      else
        format.html { render :edit }
        format.json { render json: @scraping_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scraping_rules/1
  # DELETE /scraping_rules/1.json
  def destroy
    @scraping_rule.destroy
    respond_to do |format|
      format.html { redirect_to scraping_rules_url, notice: 'Scraping rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def manage_scraping_rules
    logger.debug("the parameters for adding rule are: #{params.inspect}")

    dynamodb = Aws::DynamoDB::Client.new(region: "us-west-2")
    # table_name = 'contact_management'
    table_name = ENV["MASTER_TABLE_NAME"]

    parameters = {
        table_name: table_name,
        key: {
            url: params[:url]
        }
        # projection_expression: "url",
        # filter_expression: "url = test1.com"
    }

    result = dynamodb.get_item(parameters)[:item]

    logger.debug("***********************************************the Result of the get entry is : #{result}")
    programDetails_array = []
    result.each do |key, value|
      logger.debug("************************the key is : #{key}, and the value is : #{value.class}")
      if key.include?("Programs")
        programDetails_array.push("#{key}"=> value )
      end
    end

    logger.debug("*************************the number of programDetails are : #{programDetails_array}")
    logger.debug("!!!!!!!!!!!!!!!!!!!!!!!!!the OrgDescription is : #{result["OrganizationName"]["OrgDescription"][0].class}")


    # @row = params[:row_id]
    sr = ScrapingRule.new
    # sr.url = params[:url]
    # sr.organizationName_Text = result["OrganizationName_Text"]
    # sr.organizationName_xpath = result["OrganizationName_xpath"]
    # sr.organizationName_URL = result["OrganizationName_URL"]
    # sr.organizationDescription_Text = result["OrganizationDescription_Text"]
    # sr.organizationDescription_URL = result["OrganizationDescription_URL"]
    # sr.organizationDescription_xpath = result["OrganizationDescription_xpath"]
    sr.url = result["url"]
    sr.organizationName = result["OrganizationName"]["OrganizationName"][0]
    sr.organizationDescription = result["OrganizationName"]["OrgDescription"][0]
    sr.geoScope = result["GeoScope"]
    sr.programDetails = programDetails_array
    #
    sr.save
    respond_to do |format|
      # format.html
      format.js
    end

  end

  def validate_catalogue_entries
    rule_ids = params[:ids]

    ScrapingRule.validate_scraping_rules(rule_ids)

    respond_to do |format|
      # format.html
      format.js
    end
  end

  def remove_catalogue_entries
    rule_ids = params[:ids]
    @row_ids = params[:row_ids]

    rule_ids.each do |ri|
      catalogue_entyr = ScrapingRule.find(ri)
      catalogue_entyr.destroy!
    end

    respond_to do |format|
      # format.html
      format.js
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scraping_rule
      @scraping_rule = ScrapingRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scraping_rule_params
      params.fetch(:scraping_rule, {})
    end
end
