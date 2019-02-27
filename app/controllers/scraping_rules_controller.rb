class ScrapingRulesController < ApplicationController
  before_action :set_scraping_rule, only: [:show, :edit, :update, :destroy]

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
    @row = params[:row_id]
    sr = ScrapingRule.new
    # sr.url = params[:url]
    sr.organizationName_Text = params[:org_name]
    sr.organizationName_xpath = params[:orgName_xpath]
    sr.organizationName_URL = params[:orgName_url]
    sr.organizationDescription_Text = params[:description]
    sr.organizationDescription_URL = params[:description_url]
    sr.organizationDescription_xpath = params[:description_xpath]
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
