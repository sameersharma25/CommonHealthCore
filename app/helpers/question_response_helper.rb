module QuestionResponseHelper

  def check_for_template_type(league_segment)

    agreement_type = []
    ShowTemplate.all.each do |st|

      if st.league_segments.sort == league_segment.sort

        agreement_type.push(st.agreement_type)
        logger.debug(" IN THE HELPER insite agreementtype is condition------ #{agreement_type}")
      end
    end

    agreement_type
  end

  def get_agreement_template(agreement_type)
    ag = AgreementTemplate.where(agreement_type: agreement_type, active: true )
    logger.debug("*****************IN THE HELPER the ag is : #{ag.entries} ")
    ag
  end
end
