# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).on("click", ".wizard_add_new_role", ->
    console.log("clicked checkde button" )
    name = $("#role_name").val()
    abilities = []
    checkbox_elemenet = $(".role_abilities")
    checkbox_elemenet.each (index, element) ->
#      console.log("element is: " + element.id)
      console.log(" is: " + $(this).is(':checked'))
      if $(this).is(':checked')
        abilities.push(element.value)
    console.log("ROLE NAME IS" + name+  "the ids are: " + abilities)
    $("#role_name").val("")
    $.post "/backend/wizard_add_new_role",
      name: name,
      abilities: abilities
    return

  )