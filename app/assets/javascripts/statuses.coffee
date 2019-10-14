# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).on("click", ".wizard_add_new_status", ->
    status = $("#status_status").val()
    console.log("the status is :", status)
    $("#status_status").val("")
    $.post "/backend/wizard_add_status",
      status: status
    return


  )