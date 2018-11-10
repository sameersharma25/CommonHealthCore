class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show

  end

  # GET /tasks/new
  def new
    client_application_id = current_user.client_application_id.to_s
    @task = Task.new
    @statuses = Status.where(client_application_id: client_application_id)
    logger.debug("THE STATUS FOR TASK ARE: #{@statuses}")
  end

  # GET /tasks/1/edit
  def edit
    client_application_id = current_user.client_application_id.to_s
    @statuses = Status.where(client_application_id: client_application_id)
  end

  # POST /tasks
  # POST /tasks.json
  def create
    client_application_id = current_user.client_application_id.to_s
    @statuses = Status.where(client_application_id: client_application_id)
    @task = Task.new(task_params)


    # year = params[:task]["task_deadline(1i)"]
    # month = params[:task]["task_deadline(2i)"]
    # date = params[:task]["task_deadline(3i)"]
    # hour = params[:task]["task_deadline(4i)"]
    # minutes = params[:task]["task_deadline(5i)"]
    # task_deadline = "#{year}-#{month}-#{date} #{hour}:#{minutes}".to_datetime
    @task.task_deadline = params[:task][:task_deadline]
    @task.referral_id = "5b88078758f01af1e9435c80"

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.fetch(:task, {})
      params.require(:task).permit(:task_type, :task_status, :task_deadline)
    end
end
