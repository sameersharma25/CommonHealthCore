class QuestionResponseController < ApplicationController
  include QuestionResponseHelper

  def question_form

    @questions = Question.all
    @question_response = QuestionResponse.new
    @customer_id = current_user.client_application_id.to_s
    @client_application = ClientApplication.find(@customer_id)
    @template = "nothing"
    @client_responses = ClientApplication.find(@customer_id).question_responses.first
    # customer_response_list = QuestionResponse.where(client_application_id: @customer_id)
    # logger.debug("***********************the customer response list is : #{customer_response_list.entries}")
    # if customer_response_list.empty?
    #   Question.all.each do |q|
    #     qr = QuestionResponse.new
    #     qr.question_id = q.id.to_s
    #     qr.client_application_id = @customer_id
    #     qr.save
    #   end
    # end
    @first_question = Question.where(pq: nil).first
    # if !@client_responses.nil?
    #   segment = ClientApplication.find(@customer_id).question_responses.first.league_segments.sort
    #   agreement_type = ShowTemplate.where(league_segments: segment ).first.agreement_type
    #   @ag = AgreementTemplate.where(agreement_type: agreement_type, active: true )
    # end

  end

  def save_question_response
    # params["5d48a68458f01a25d1b5721d"] = covered Entity
    # params["5d48a6d058f01a25d1b5721e"] = business associate
    # params["5d48a6e558f01a25d1b5721f"] = non-hippa entiry
    # params["5d48a70758f01a25d1b57220"] = care coordination
    # params["5d4a66dc58f01a25d1b57221"] = source
    # params["5d4a66fa58f01a25d1b57222"] = destination

    league_segment = []
    if (params["are_you_referral_source"] == "yes" || params["are_you_referral_destination"] == "yes" ) && params["are_you_a_covered_entity"] == "yes"
      league_segment.push("2")
    end
    if params["are_you_referral_source"] == "yes" && params["are_you_a_business_associate"] == "yes"
      league_segment.push("3")
    end

    if params["are_you_referral_destination"] == "yes" && params["are_you_a_business_associate"] == "yes"
      league_segment.push("4")
    end
    if params["are_you_a_covered_entity"] == "yes" && params["are_you_interested_in_providding_care_coordination_activities"] == "yes"
      league_segment.push("5")
    end
    if params["are_you_interested_in_providding_care_coordination_activities"] == "yes" && params["are_you_a_business_associate"] == "yes"
      logger.debug("***********before 6------------")
      league_segment.push("6")
    end

    client_application_response = ClientApplication.find(params["client_application_id"]).question_responses

    if client_application_response.empty?
      logger.debug("CREATING NEW RESPONSES************************")
      qr = QuestionResponse.new
    else
      logger.debug("EXISTING RESPONSE***************")
      qr_id = client_application_response.first.id.to_s
      qr = QuestionResponse.find(qr_id)
    end


    qr.client_application_id = params["client_application_id"]
    qr.league_segments = league_segment
    qr.save


    agreement_type = helpers.check_for_template_type(league_segment)[0]

    @template = helpers.get_agreement_template(agreement_type).first


    logger.debug("the league segment is #{league_segment}: #{qr}-----------#{agreement_type.inspect}")
  end


  def next_question

    @customer_id = params[:cus_id]

    q = Question.find(params[:ques_id])
    qr = QuestionResponse.where(client_application_id: params[:cus_id], question_id: params[:ques_id]).first

    if qr.nil?
      logger.debug("Creating new RESPONSE##############******************")
      qr = QuestionResponse.new
      qr.question_response = params[:answer]
      qr.question_id = params[:ques_id]
      qr.client_application_id = params[:cus_id]
      if qr.save
        logger.debug("QUESTION RESPONSER WASS SAVEDDDDDDDDDDDDDDDDDDDDDDDDDD")
      else

        logger.debug("WHY IS IT NOT SAVINGGGGGGGGGG #{qr.inspect}")
      end
    else
      logger.debug("UPDATING EXISTING RESPONSE**************************")
      qr.question_response = params[:answer]
      qr.question_id = params[:ques_id]
      qr.client_application_id = params[:cus_id]
      qr.save
    end

    if params[:answer] == "yes"

      if q.nqy.nil?
        logger.debug("YES do something for no next question***********")
        @template = display_template(@customer_id)
      else
        @next_question = Question.find(q.nqy)
      end

    elsif params[:answer] == "no"
      if q.nqn.nil?
        logger.debug("NO do something for no next quesiion**************")
        @template = display_template(@customer_id)
      else
        @next_question = Question.find(q.nqn)
      end
    end
    @client_application = ClientApplication.find(@customer_id)
  end


  def display_template(customer_id)
    logger.debug("going into the DISPLAY TEMPLATE*****************")
    true_array = []
    customer = ClientApplication.find(customer_id)
    customer.question_responses.each do |qr|
      if qr.question_response == true
        true_array.push(qr.question_id)
      end
    end
    logger.debug("the true array is #{true_array}")
    agreement_type = helpers.check_for_template_type(true_array)[0]
    logger.debug("the AGREEMENT TYPE IS: #{agreement_type}")
    customer.agreement_type = agreement_type
    customer.save
    template = helpers.get_agreement_template(agreement_type).first
  end

  # def check_for_template_type(league_segment)
  #
  #   agreement_type = []
  #   ShowTemplate.all.each do |st|
  #
  #     if st.league_segments.sort == league_segment.sort
  #
  #       agreement_type.push(st.agreement_type)
  #       logger.debug("insite agreementtype is condition------ #{agreement_type}")
  #     end
  #   end
  #
  #   agreement_type
  # end

  def get_agreement_template(agreement_type)
    ag = AgreementTemplate.where(agreement_type: agreement_type, active: true )
    # logger.debug("*****************the ag is : #{ag.entries} ")

  end

end
