# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).on("click", ".wizard_add_new_notification_rule", ->
    status = $("#notification_rule_appointment_status").val();
    time = $("#notification_rule_time_difference").val();
    subject = $("#notification_rule_subject").val();
    body= $("#notification_rule_body").val();
    user_type= $("#notification_rule_user_type").val();

    $("#notification_rule_time_difference").val("");
    $("#notification_rule_subject").val("");
    $("#notification_rule_body").val("");

    $.post "/backend/wizard_add_notification",
      status: status,
      time: time,
      subject: subject,
      body: body,
      user_type: user_type
    return

  )