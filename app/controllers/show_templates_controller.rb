class ShowTemplatesController < ApplicationController
  before_action :set_show_template, only: [:show, :edit, :update, :destroy]

  # GET /show_templates
  # GET /show_templates.json
  def index
    @show_templates = ShowTemplate.all
  end

  # GET /show_templates/1
  # GET /show_templates/1.json
  def show
  end

  # GET /show_templates/new
  def new
    @show_template = ShowTemplate.new
  end

  # GET /show_templates/1/edit
  def edit
  end

  # POST /show_templates
  # POST /show_templates.json
  def create
    @show_template = ShowTemplate.new(show_template_params)

    respond_to do |format|
      if @show_template.save
        format.html { redirect_to @show_template, notice: 'Show template was successfully created.' }
        format.json { render :show, status: :created, location: @show_template }
      else
        format.html { render :new }
        format.json { render json: @show_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /show_templates/1
  # PATCH/PUT /show_templates/1.json
  def update
    respond_to do |format|
      if @show_template.update(show_template_params)
        format.html { redirect_to @show_template, notice: 'Show template was successfully updated.' }
        format.json { render :show, status: :ok, location: @show_template }
      else
        format.html { render :edit }
        format.json { render json: @show_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /show_templates/1
  # DELETE /show_templates/1.json
  def destroy
    @show_template.destroy
    respond_to do |format|
      format.html { redirect_to show_templates_url, notice: 'Show template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show_template
      @show_template = ShowTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_template_params
      params.fetch(:show_template, {})
    end
end
