# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  console.log("Client Application Coffee****")
  $(document).on("click", ".requested_application", ->
    id = $(this).attr("id")
    console.log("the id of the invite is ", id)
    $.post "/send_application_invitation",
      id: id
    return
  )

  $('#notification_rules').DataTable();

  $('#user_list').DataTable({ responsive: true });

  $('#client_application').DataTable( );

  $('#contact_management_table').DataTable( "order": []);

  $(document).on("click", ".external_api_setup", ->
#    text = $("#send_patient").val()
    client_id = $("#client_application_id").val()
    api_array = []
    $(".external_api_text_field").each ->
      id=  $(this).attr('id')
      text = $(this).val()
      h = {id: id, text: text }
      if text.length != 0
        api_array.push(h)
      console.log("the id is : ", id, 'the text is :', text)

    console.log("the array from js is :", api_array, "Client ID is : ", client_id  )
    $.post "/after_signup_external/api_setup",
      api_array: api_array,
      client_id: client_id
    return
  )

  #Send for approval 
  $(document).on("click", ".add_rule", ->
    
    row_id = $(this).attr("id")
    console.log("in the add rule function", row_id)
    numVal = parseInt(row_id) - 2
    catalogName = $('.nameOrg')[numVal].innerHTML
    url_id = $('.myURL')[numVal].innerHTML
    console.log("Looking for URL", url_id)
    console.log("the row id is: ", row_id, catalogName)
    $.post "/send_for_approval",
      orgName: catalogName
      url: url_id
    return
    )

  #Delete Catalog Entry  
  $(document).on("click", ".delete_rule", ->
    
    row_id = $(this).attr("id")
    console.log("in the delete rule function", row_id)
    numVal = parseInt(row_id) - 2
    url_id = $('.myURL')[numVal].innerHTML
    woof = $('#rule_' + row_id)
    woof.hide();

    $.post "/delete_catalog",
      url: url_id
    return

    )

  #Approve Catalog Entry  
  $(document).on("click", ".approve_rule", ->
    
    row_id = $(this).attr("id")
    console.log("in the approve rule function", row_id)
    numVal = parseInt(row_id) - 2
    url_id = $('.myURL')[numVal].innerHTML
    woof = $('#masterRule_' + row_id)
    woof.hide();

    $.post "/approve_catalog",
      url: url_id
    return

    )
  #Reject Catalog Entry  
  $(document).on("click", ".reject_rule", ->
    row_id = $(this).attr("id")
    console.log("in the reject rule function", row_id)
    numVal = parseInt(row_id) - 2
    url_id = $('.myURL')[numVal].innerHTML
    woof = $('#masterRule_' + row_id)
    woof.hide();
    $.post "/reject_catalog",
      url: url_id
    return
    )
