class BaaLanguageSegmentsController < ApplicationController
  before_action :set_baa_language_segment, only: [:show, :edit, :update, :destroy]

  # GET /baa_language_segments
  # GET /baa_language_segments.json
  def index
    @baa_language_segments = BaaLanguageSegment.all
  end

  # GET /baa_language_segments/1
  # GET /baa_language_segments/1.json
  def show
  end

  # GET /baa_language_segments/new
  def new
    @baa_language_segment = BaaLanguageSegment.new
  end

  # GET /baa_language_segments/1/edit
  def edit
  end

  # POST /baa_language_segments
  # POST /baa_language_segments.json
  def create
    @baa_language_segment = BaaLanguageSegment.new(baa_language_segment_params)

    respond_to do |format|
      if @baa_language_segment.save
        format.html { redirect_to @baa_language_segment, notice: 'Baa language segment was successfully created.' }
        format.json { render :show, status: :created, location: @baa_language_segment }
      else
        format.html { render :new }
        format.json { render json: @baa_language_segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /baa_language_segments/1
  # PATCH/PUT /baa_language_segments/1.json
  def update
    respond_to do |format|
      if @baa_language_segment.update(baa_language_segment_params)
        format.html { redirect_to @baa_language_segment, notice: 'Baa language segment was successfully updated.' }
        format.json { render :show, status: :ok, location: @baa_language_segment }
      else
        format.html { render :edit }
        format.json { render json: @baa_language_segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /baa_language_segments/1
  # DELETE /baa_language_segments/1.json
  def destroy
    @baa_language_segment.destroy
    respond_to do |format|
      format.html { redirect_to baa_language_segments_url, notice: 'Baa language segment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_baa_language_segment
      @baa_language_segment = BaaLanguageSegment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def baa_language_segment_params
      params.fetch(:baa_language_segment, {})
    end
end
