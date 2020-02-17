module InterviewsHelper

  def assessments_list(referrals)
    interview_list_array = []
    referrals.each do |ref|
      patient_id = ref.patient.id.to_s
      patient = Patient.find(patient_id)
      caller_first_name = patient.last_name + " "+ patient.first_name
      int_created_at = patient.created_at
      need_title = ref.needs.first.need_title if ref.needs.first
      obstacle_title = ref.needs.first.obstacles.first.obstacle_title if (ref.needs.first && ref.needs.first.obstacles.first)
      interview_hash = {patient_id: patient_id,interview_id: patient_id ,referral_id: ref.id.to_s,created_at: int_created_at, caller_first_name: caller_first_name, need_title: need_title, obstacle_title: obstacle_title }
      interview_list_array.push(interview_hash)
    end

    interview_list_array
  end

end