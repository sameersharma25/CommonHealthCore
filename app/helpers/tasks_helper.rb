module TasksHelper
  def create_ledger_master_and_status(task)
    lm = LedgerMaster.new
    lm.task_id = task.id.to_s
    # lm.patient_id = patient_id
    if lm.save
      led_stat = LedgerStatus.new
      led_stat.ledger_master_id = lm.id.to_s
      led_stat.ledger_status = "Accepted"
      led_stat.save
    end
  end
end
