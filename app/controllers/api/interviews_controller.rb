module Api
  class InterviewsController < ActionController::Base

    def new_interview

      user = User.find_by(email: params[:email])
      client_application = user.client_application

      new_call = Interview.new
      new_call.caller_first_name = params[:caller_first_name]
      new_call.caller_last_name = params[:caller_last_name] if params[:caller_last_name]
      new_call.caller_dob = params[:caller_dob] if params[:caller_dob]
      new_call.client_application_id = client_application.id.to_s
      new_call.save

      render :json => {status: :ok , interview_id: new_call.id.to_s }

    end

    def update_interview

      call = Interview.find(params[:interview_id])
      call.caller_last_name = params[:caller_last_name] if params[:caller_last_name]
      call.caller_dob = params[:caller_dob] if params[:caller_dob]
      call.caller_address = params[:caller_address] if params[:caller_address]
      call.caller_zipcode = params[:caller_zipcode] if params[:caller_zipcode]
      call.caller_state = params[:caller_state] if params[:caller_state]
      add_fields = params["caller_additional_fields"]
      logger.debug("the ADDITIONAL FIELDS ARE: #{add_fields}******************")
      call.caller_additional_fields = params["caller_additional_fields"].to_unsafe_h if params[:caller_additional_fields]
      call.save

      render :json => {status: :ok}
    end

    def new_need
      new_need = Need.new
      new_need.need_title = params[:need_title]
      new_need.interview_id = params[:interview_id]
      new_need.need_description = params[:need_description] if params[:need_description]
      new_need.save

      render :json => {status: :ok, need_id: new_need.id.to_s}
    end

    def update_need
      need = Need.find(params[:need_id])
      need.need_description = params[:need_description] if params[:need_description]
      need.need_notes = params[:need_notes] if params[:need_notes]
      need.need_urgency = params[:need_urgency] if params[:need_urgency]
      need.need_status = params[:need_status] if params[:need_status]

      need.save

      render :json => {status: :ok}

    end

    def new_obstacle
      new_obstacle = Obstacle.new
      new_obstacle.obstacle_title = params[:obstacle_title]
      new_obstacle.obstacle_description = params[:obstacle_description] if params[:obstacle_description]
      new_obstacle.need_id = params[:need_id]
      new_obstacle.save

      render :json => {status: :ok, obstacle_id: new_obstacle.id.to_s}
    end

    def update_obstacle
      obstacle = Obstacle.find(params[:obstacle_id])
      obstacle.obstacle_description = params[:obstacle_description] if params[:obstacle_description]
      obstacle.obstacle_notes = params[:obstacle_notes] if params[:obstacle_notes]
      obstacle.obstacle_urgency = params[:obstacle_urgency] if params[:obstacle_urgency]
      obstacle.obstacle_status = params[:obstacle_status] if params[:obstacle_status]

      obstacle.save

      render :json => {status: :ok }

    end

    def new_solution
      new_sol = Solution.new
      new_sol.solution_title = params[:solution_title]
      new_sol.obstacle_id = params[:obstacle_id]
      new_sol.save

      render :json => {status: :ok, solution_id: new_sol.id.to_s}

    end

    def update_soulution
      solution = Solution.find(params[:solution_id])
      solution.solution_title = params[:solution_title] if params[:solution_title]
      solution.solution_description = params[:solution_description] if params[:solution_description]
      solution.save

      render :json => {status: :ok }
    end

    def interview_list
      client_application_id = User.find_by(email: params[:email]).client_application_id
      client_interviews = Interview.where(client_application_id: client_application_id)
      interview_list_array = []
      client_interviews.each do |ci|
        interview_id = ci.id.to_s
        caller_first_name = ci.caller_first_name
        need_title = ci.needs.first.need_title if ci.needs.first
        obstacle_title = ci.needs.first.obstacles.first.obstacle_title if (ci.needs.first && ci.needs.first.obstacles.first)
        interview_hash = {interview_id: interview_id, caller_first_name: caller_first_name, need_title: need_title, obstacle_title: obstacle_title }
        interview_list_array.push(interview_hash)
      end

      render :json => {status: :ok, interview_list: interview_list_array}
    end


    def interview_details
      interview = Interview.find(params[:interview_id])
      need = interview.needs.first
      obstacle = need.obstacles.first if (need && need.obstacles)

      interview_hash = {caller_first_name: interview.caller_first_name, caller_last_name: interview.caller_last_name,
                        caller_dob: interview.caller_dob, caller_address: interview.caller_address,
                        caller_zipcode: interview.caller_zipcode, caller_state: interview.caller_state}

      need_hash = {need_title: need.need_title, need_description: need.need_description, need_note: need.need_notes,
                   need_urgency: need.need_urgency, need_status: need.need_status} if need

      obstacle_hash = {obstacle_title: obstacle.obstacle_title, obstacle_description: obstacle.obstacle_description,
                       obstacle_notes: obstacle.obstacle_notes, obstacle_urgency: obstacle.obstacle_urgency,
                       obstacle_status: obstacle.obstacle_status} if obstacle

      render :json => {status: :ok, interview_hash: interview_hash, need_hash: need_hash, obstacle_hash: obstacle_hash }
    end

  end
end