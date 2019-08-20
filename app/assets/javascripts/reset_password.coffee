# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


  $(document).on("click", "#resetPassword", ->
    theUser = $('#fooFighter').val()
    console.log("said", theUser)
    $.post "/reset_password_part_two",
      user: theUser 
    return
    )