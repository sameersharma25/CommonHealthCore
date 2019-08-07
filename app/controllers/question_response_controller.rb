class QuestionResponseController < ApplicationController


  def question_form

    @questions = Question.all
    @question_response = QuestionResponse.new
    @customer_id = current_user.client_application_id.to_s
    @template = "nothing"


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

    qr = QuestionResponse.new
    qr.client_application_id = params["client_application_id"]
    qr.league_segments = league_segment
    qr.save


    agreement_type = check_for_template_type(league_segment)[0]

    @template = get_agreement_template(agreement_type).first


    logger.debug("the league segment is #{league_segment}: #{qr}-----------#{agreement_type.inspect}")
  end

  def check_for_template_type(league_segment)

    agreement_type = []
    ShowTemplate.all.each do |st|

      if st.league_segments.sort == league_segment.sort

        agreement_type.push(st.agreement_type)
        logger.debug("insite agreementtype is condition------ #{agreement_type}")
      end
    end

    agreement_type
  end

  def get_agreement_template(agreement_type)
    ag = AgreementTemplate.where(agreement_type: agreement_type, active: true )
    # logger.debug("*****************the ag is : #{ag.entries} ")

  end

end
