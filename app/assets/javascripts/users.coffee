# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->

  get_data = (evt) ->
    #alert(evt.data)
#    $("#user_email_1").val("defaultuser@test.com")
    msg = evt.data.split(',')[0]
    if msg == "login"
      alert("You are logging into the Common Health Core as an Administrator");
      user = evt.data.split(',')[1]
      pwd = evt.data.split(',')[2]
      $("#user_email_1").val(user)
#    $("#user_password").val("1234567")
      $("#next_login").trigger("click")
#     $("#user_email").val("firstu@test.com")
#     $("#user_password").val("123456")
      $("#user_email").val(user)
      $("#user_password").val(pwd)
      $("#step-B").submit()
      alert("after login")
    else if msg == "logout"
      #alert("else")
      #$("#logoutID a").trigger("click")
      $.ajax({ 
      type: 'GET', 
      url: 'users/sign_out' 
      });
      console.log("After click")
      alert("Logging out of Common Health Core.")
      return

  $(document).ready ->
    window.addEventListener("message", get_data,false)
#    alert("after the listner")

  $(document).on("click",".wizard_add_new_user", ->
    console.log("clicked checkde button" )
    name = $("#user_name").val()
    email = $("#user_email").val()
    id = []
    checkbox_elemenet = $(".wizard_roles_checkboxes")
    checkbox_elemenet.each (index, element) ->
#      console.log("element is: " + element.id)
      console.log(" is: " + $(this).is(':checked'))
      if $(this).is(':checked')
        id.push(element.id)
    console.log("the ids are: " + id)
    $("#user_name").val("")
    $("#user_email").val("")
    $.post "/backend/wizard_add_user",
      name: name,
      email: email,
      role_ids: id
    return
  )



#  window.parent.document.getElementById("element_id");


