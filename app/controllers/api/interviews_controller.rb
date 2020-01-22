module Api
  class InterviewsController < ActionController::Base
    include UsersHelper
    include InterviewsHelper

    def new_interview

      user = User.find_by(email: params[:email])
      user_id = user.id.to_s
      client_application = user.client_application

      # new_call = Interview.new
      # new_call.caller_first_name = params[:caller_first_name]
      # new_call.caller_last_name = params[:caller_last_name] if params[:caller_last_name]
      # new_call.caller_dob = params[:caller_dob] if params[:caller_dob]
      # new_call.client_application_id = client_application.id.to_s
      # new_call.save
      patient = Patient.new
      patient.first_name = params[:caller_first_name]
      patient.last_name = params[:caller_last_name] if params[:caller_last_name]
      patient.date_of_birth = params[:caller_dob] if params[:caller_dob]
      patient.client_application_id = client_application.id.to_s
      patient.through_call = true
      patient.patient_created_by = user_id
      if patient.save
        referral = Referral.new
        referral.referral_name = "Interview Call"
        referral.source = "Call"
        referral.client_application_id = client_application.id.to_s
        referral.patient_id = patient.id.to_s
        referral.referral_type = "Interview"
        referral.ref_created_by = user_id
        if referral.save
          task = Task.new
          task.task_type = "Interview"
          task.referral_id = referral.id.to_s
          task.security_keys = helpers.security_keys_for_task(task, patient)
          if task.save
            helpers.create_ledger_master_and_status(task)
          end
        end

        render :json => {status: :ok , interview_id: patient.id.to_s, referral_id: referral.id.to_s }
      end




    end

    def update_interview

      patient = Patient.find(params[:interview_id])
      patient.first_name = params[:caller_first_name] if params[:caller_first_name]
      patient.last_name = params[:caller_last_name] if params[:caller_last_name]
      patient.date_of_birth = params[:caller_dob] if params[:caller_dob]
      patient.patient_address = params[:caller_address] if params[:caller_address]
      patient.patient_zipcode = params[:caller_zipcode] if params[:caller_zipcode]
      patient.patient_state = params[:caller_state] if params[:caller_state]
      patient.caller_additional_fields = params["caller_additional_fields"].to_unsafe_h if params[:caller_additional_fields]
      patient.save
      # call = Interview.find(params[:interview_id])
      # call.caller_last_name = params[:caller_last_name] if params[:caller_last_name]
      # call.caller_dob = params[:caller_dob] if params[:caller_dob]
      # call.caller_address = params[:caller_address] if params[:caller_address]
      # call.caller_zipcode = params[:caller_zipcode] if params[:caller_zipcode]
      # call.caller_state = params[:caller_state] if params[:caller_state]


      # add_fields = params["caller_additional_fields"]
      # logger.debug("the ADDITIONAL FIELDS ARE: #{add_fields}******************")
      # call.caller_additional_fields = params["caller_additional_fields"].to_unsafe_h if params[:caller_additional_fields]
      # call.save

      render :json => {status: :ok}
    end

    def new_need
      ref = Referral.find(params[:referral_id])
      ref.referral_type = "Interview"
      ref.save
      patient_id = ref.patient.id.to_s
      new_need = Need.new
      new_need.need_title = params[:need_title]
      # new_need.patient_id = params[:interview_id]
      new_need.patient_id = patient_id
      new_need.need_description = params[:need_description] if params[:need_description]
      new_need.referral_id = params[:referral_id]
      new_need.save

      render :json => {status: :ok, need_id: new_need.id.to_s}
    end

    def update_need
      need = Need.find(params[:need_id])
      need.need_title = params[:need_title] if params[:need_title]
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
      obstacle.obstacle_title = params[:obstacle_title] if params[:obstacle_title]
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
      new_sol.solution_description = params[:solution_description] if params[:solution_description]
      new_sol.solution_provider = params[:solution_provider] if params[:solution_provider]
      new_sol.save

      render :json => {status: :ok, solution_id: new_sol.id.to_s}

    end

    def update_soulution
      solution = Solution.find(params[:solution_id])
      solution.solution_title = params[:solution_title] if params[:solution_title]
      solution.solution_description = params[:solution_description] if params[:solution_description]
      solution.solution_provider = params[:solution_provider] if params[:solution_provider]
      solution.save

      render :json => {status: :ok }
    end

    def interview_list
      client_application_id = User.find_by(email: params[:email]).client_application_id
      referrals = Referral.where(client_application_id: client_application_id, referral_type: "Interview" )

      # client_interviews = Patient.where(client_application_id: client_application_id, through_call: true )
      #
      # client_interviews.each do |ci|
      #   patient_id = ci.id.to_s
      #   caller_first_name = ci.first_name
      #   int_created_at = ci.created_at
      #   need_title = ci.needs.first.need_title if ci.needs.first
      #   obstacle_title = ci.needs.first.obstacles.first.obstacle_title if (ci.needs.first && ci.needs.first.obstacles.first)
      #   interview_hash = {interview_id: patient_id ,created_at: int_created_at, caller_first_name: caller_first_name, need_title: need_title, obstacle_title: obstacle_title }
      #   interview_list_array.push(interview_hash)
      # end
      interview_list = helpers.assessments_list(referrals)
      # interview_list = interview_list_array#.order(caller_first_name: :asc)
      render :json => {status: :ok, interview_list: interview_list}
    end

    def remove_need
      need = Need.find(params[:need_id])
      obstacles = need.obstacles
      obstacles.each do |obs|
        soultions = obs.solutions
        soultions.each do |solu|
          sol_id = solu.id.to_s
          Solution.find(sol_id).destroy
        end
        obs.destroy
      end
      need.destroy
      render :json => {status: :ok, message: "Need Removed"}
    end

    def remove_obstacle
      obstacle = Obstacle.find(params[:obstacle_id])
      soultions = obstacle.solutions
      soultions.each do |solu|
        sol_id = solu.id.to_s
        Solution.find(sol_id).destroy
      end
      obstacle.destroy
      render :json => {status: :ok, message: "Obstacle Removed"}
    end

    def remove_solution
      Solution.find(params[:solution_id]).destroy
      render :json => {status: :ok, messageg: "Solution Removedd"}
    end


    def interview_details_test
      # interview = Interview.find(params[:interview_id])

      # interview = Patient.find(params[:interview_id])
      # need = interview.needs.first
      # obstacle = need.obstacles.first if (need && need.obstacles)
      referral = Referral.find(params[:referral_id])

      details_array = []
      # needs = interview.needs
      needs = referral.needs

      #{need_array: [{need_id: 1, need_title: "title", obstacles_array: [{obstacle_id: o1, obs_title: "OT", solution_array: []] }]}

      # {need_array: [{need_id: 1, need_title: "title", obstacles_array: [{}] }]}
      # o_h = {obstacle_id: o1, obs_title: "OT"}
      needs.each do |need|
        need_id = need.id.to_s
        need_title =  need.need_title,
        need_description = need.need_description,
        need_note = need.need_notes,
        need_urgency = need.need_urgency,
        need_status = need.need_status

        logger.debug("******************the need Title is : #{need.inspect}")
        need_hash = {need_id: need_id, need_title: need_title.first, need_description: need_description,
                     need_note: need_note, need_urgency: need_urgency, need_status: need_status,
                      obstacles_array: []}
        logger.debug("******************the need HASH is : #{need_hash}")

        need_obstacles = need.obstacles
        need_obstacles.each do |obstacle|
          obstacle_id = obstacle.id.to_s
          obstacle_title = obstacle.obstacle_title,
          obstacle_description = obstacle.obstacle_description,
          obstacle_notes = obstacle.obstacle_notes,
          obstacle_urgency = obstacle.obstacle_urgency,
          obstacle_status = obstacle.obstacle_status

          obstacle_hash = { obstacle_id: obstacle_id,obstacle_title: obstacle_title.first,
                            obstacle_description: obstacle_description,
                           obstacle_notes: obstacle_notes, obstacle_urgency: obstacle_urgency,
                           obstacle_status: obstacle_status, solutions_array: []}


          obstacle_solutions = obstacle.solutions
          obstacle_solutions.each do |solution|
            solution_id = solution.id.to_s
            solution_title = solution.solution_title
            solution_description = solution.solution_description
            solution_provider = solution.solution_provider
            logger.debug("the NEED IS : #{need}******the OBSTACLE IS : #{obstacle}******** THE SOLUTION IS : #{solution}")
            task_id = ''
            task_id = Task.where(solution_id: solution_id ).first.id.to_s if !Task.where(solution_id: solution_id ).first.nil?
            task_transferable = ''
            task_transferable = Task.where(solution_id: solution_id ).first.transferable if !Task.where(solution_id: solution_id ).first.nil?
            solution_hash = {solution_id: solution_id, solution_title: solution_title,
                             solution_description: solution_description, solution_provider: solution_provider,
                             task_id: task_id, task_transferable: task_transferable}
            obstacle_hash[:solutions_array].push(solution_hash) if solution_hash
          end
          need_hash[:obstacles_array].push(obstacle_hash)
        end

        details_array.push(need_hash)
      end



      # interview_hash = {caller_first_name: interview.first_name, caller_last_name: interview.last_name,
      #                   caller_dob: interview.date_of_birth, caller_address: interview.patient_address,
      #                   caller_zipcode: interview.patient_zipcode, caller_state: interview.patient_state,
      #                   caller_additional_fields: interview.caller_additional_fields}

      interview_hash = { }
      # need_hash = {need_title: need.need_title, need_description: need.need_description, need_note: need.need_notes,
      #              need_urgency: need.need_urgency, need_status: need.need_status} if need

      # obstacle_hash = {obstacle_title: obstacle.obstacle_title, obstacle_description: obstacle.obstacle_description,
      #                  obstacle_notes: obstacle.obstacle_notes, obstacle_urgency: obstacle.obstacle_urgency,
      #                  obstacle_status: obstacle.obstacle_status} if obstacle

      render :json => {status: :ok, interview_hash: interview_hash, details_array: details_array  }

    end


    def interview_details
      # interview = Interview.find(params[:interview_id])

      interview = Patient.find(params[:interview_id])
      # need = interview.needs.first
      # obstacle = need.obstacles.first if (need && need.obstacles)
      # referral = Referral.find(params[:referral_id])

      referrals = interview.referrals.where(referral_type: "Interview")
      details_array = []

      #needs = interview.needs

      # needs = referral.needs

      #{need_array: [{need_id: 1, need_title: "title", obstacles_array: [{obstacle_id: o1, obs_title: "OT", solution_array: []] }]}

      # {need_array: [{need_id: 1, need_title: "title", obstacles_array: [{}] }]}
      # o_h = {obstacle_id: o1, obs_title: "OT"}

      referrals.each do |r|
        r.needs.each do |need|
          need_id = need.id.to_s
          need_title =  need.need_title,
              need_description = need.need_description,
              need_note = need.need_notes,
              need_urgency = need.need_urgency,
              need_status = need.need_status

          logger.debug("******************the need Title is : #{need.inspect}")
          need_hash = {need_id: need_id, need_title: need_title.first, need_description: need_description,
                       need_note: need_note, need_urgency: need_urgency, need_status: need_status,
                       obstacles_array: []}
          logger.debug("******************the need HASH is : #{need_hash}")

          need_obstacles = need.obstacles
          need_obstacles.each do |obstacle|
            obstacle_id = obstacle.id.to_s
            obstacle_title = obstacle.obstacle_title,
                obstacle_description = obstacle.obstacle_description,
                obstacle_notes = obstacle.obstacle_notes,
                obstacle_urgency = obstacle.obstacle_urgency,
                obstacle_status = obstacle.obstacle_status

            obstacle_hash = { obstacle_id: obstacle_id,obstacle_title: obstacle_title.first,
                              obstacle_description: obstacle_description,
                              obstacle_notes: obstacle_notes, obstacle_urgency: obstacle_urgency,
                              obstacle_status: obstacle_status, solutions_array: []}


            obstacle_solutions = obstacle.solutions
            obstacle_solutions.each do |solution|
              solution_id = solution.id.to_s
              solution_title = solution.solution_title
              solution_description = solution.solution_description
              solution_provider = solution.solution_provider
              task_id = Task.find_by(solution_id: solution_id ).id.to_s
              task_transferable = Task.find_by(solution_id: solution_id ).transferable

              solution_hash = {solution_id: solution_id, solution_title: solution_title,
                               solution_description: solution_description, solution_provider: solution_provider,
                               task_id: task_id, task_transferable: task_transferable}
              obstacle_hash[:solutions_array].push(solution_hash) if solution_hash
            end
            need_hash[:obstacles_array].push(obstacle_hash)
          end

          details_array.push(need_hash)
        end
      end


      interview_hash = {caller_first_name: interview.first_name, caller_last_name: interview.last_name,
                        caller_dob: interview.date_of_birth, caller_address: interview.patient_address,
                        caller_zipcode: interview.patient_zipcode, caller_state: interview.patient_state,
                        caller_additional_fields: interview.caller_additional_fields}


      # need_hash = {need_title: need.need_title, need_description: need.need_description, need_note: need.need_notes,
      #              need_urgency: need.need_urgency, need_status: need.need_status} if need

      # obstacle_hash = {obstacle_title: obstacle.obstacle_title, obstacle_description: obstacle.obstacle_description,
      #                  obstacle_notes: obstacle.obstacle_notes, obstacle_urgency: obstacle.obstacle_urgency,
      #                  obstacle_status: obstacle.obstacle_status} if obstacle

      render :json => {status: :ok, interview_hash: interview_hash, details_array: details_array  }

    end

    def active_needs

      user = User.find_by(email: params[:email])
      client_application= user.client_application
      patients = client_application.patients
      patient_id_array = []

      patients.each do |p|
        needs = p.needs

        needs.each do |need|
          obstacles = need.obstacles
          obstacles.each do |obstacle|
            solutions = obstacle.solutions
            solutions.each do |solution|
              solution_id = solution.id.to_s
              sol_task = Task.where(solution_id: solution_id)
              if sol_task.blank?
                patient_id_array.push(p.id.to_s)
              end
            end
          end
        end
      end

      final_patient_ids = patient_id_array.uniq()




    end



  end
end