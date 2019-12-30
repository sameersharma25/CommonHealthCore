# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  console.log("Client Application Coffee****")
  $(document).on("click", ".requested_application", ->
    id = $(this).attr("id")
    console.log("the id of the invite is ", id)
    $.post "/backend/send_application_invitation",
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
    $.post "/backend/after_signup_external/api_setup",
      api_array: api_array,
      client_id: client_id
    return
  )

  #Send for approval 
  $(document).on("click", ".add_rule", ->
    row_id = $(this).attr("id")
    console.log("in the add rule function", row_id)
    numVal = parseInt(row_id) - 2
    catalogName = $('#nameOfOrg_'+ row_id).text()
    console.log("the row id is: ", row_id, catalogName)
    url_id = $('#url_'+row_id).text().replace(/^\s+|\s+$/g, '')
    console.log("Looking for URL", url_id)

    $.post "/backend/send_for_approval",
      orgName: catalogName
      url: url_id
    return
    )

  #Delete Catalog Entry  
  $(document).on("click", ".delete_rule", ->    
    row_id = $(this).attr("id")
    console.log("in the delete rule function", row_id)
    numVal = parseInt(row_id) - 2 
    console.log("What", $('#url_' +row_id)[0].innerText)
    #url_id = $('.myURL')[numVal].innerHTML.replace(/^\s+|\s+$/g, '')
    url_id = $('#url_' +row_id)[0].innerText.replace(/^\s+|\s+$/g, '')

    woof = $('#rule_' + row_id)
    woof.hide();

    $.post "/backend/delete_catalog",
      url: url_id
    return

    )

  #Approve Catalog Entry  
  $(document).on("click", ".approve_rule", ->
    row_id = $(this).attr("id")
    console.log("in the approve rule function", row_id)
    numVal = parseInt(row_id) - 2
    url_id = $('.masterURL')[numVal].innerHTML
    pocEmail = $('#hiddenEmail_' + row_id)[0].name
    console.log("my POC Email", pocEmail)
    woof = $('#masterRule_' + row_id)
    woof.hide();
    $.post "/backend/approve_catalog",
      url: url_id
      pocEmail: pocEmail
    return
    )

  #Reject Catalog Entry  
  $(document).on("click", ".reject_rule", ->
    row_id = $(this).attr("id")
    console.log("in the reject rule function", row_id)
    numVal = parseInt(row_id) - 2
    url_id = $('.masterURL')[numVal].innerHTML.replace(/^\s+|\s+$/g, '')

    #Display Reason
    displayObjects = $('.displayReason_' + row_id)
    displayObjects.show();

    ) 
  #submitReject Reason  
  $(document).on("click", "#submitReason", ->
    row_id = $(this).attr("class")    
    idVal = row_id.split('_')[1]
    numVal = parseInt(idVal) - 2
    url_id = $('.masterURL')[numVal].innerHTML.replace(/^\s+|\s+$/g, '')

    textValue = $('#rejectText_' + idVal)
    console.log("he ha har", textValue[0].value, "my url", url_id)
    #
    woof = $('#masterRule_' + idVal)
    woof.hide();
    
    $.post "/backend/reject_catalog",
      url: url_id
      rejectReason: textValue[0].value
    return

    )
  $(document).on("click",".agreement_activate_button", ->
    id = $(this).attr("id")
    console.log("the id of the activate button is", id)
    $.post "/backend/change_status_of_agreement_template",
      id: id
    return

  )
  # AgreementTemplateShowReasonForReject
  $(document).on("click", ".reject_agreement", ->
    row_id = $(this).attr("id")
    console.log("the row id is:", row_id)
    $(".reason_for_reject_"+row_id).removeClass("hide")
  )

  $(document).on("click",".submit_reason_for_agreement_reject", ->
    id = $(this).attr("id")
    text = $(".reason_for_agreement_reject_"+id).val()
    cus_id = $(".reason_for_agreement_reject_"+id).attr("id")
    console.log("the text is: ", text)
    $.post "/backend/reject_agreement_template",
      reason_for_reject: text,
      cus_id: cus_id
    return

  )

  $(document).on("change", ".que_sequence", ->

    question = $(this).attr("id")
    changed_value = $(this).val()
    change_param = $(this).attr("name")
    console.log("IN the change method***", $(this).attr("id"), "tewoiwororwrhworw", $(this).val(), $(this).attr("name"))
    $.post "/backend/update_sequence",
      question: question,
      changed_value: changed_value,
      change_param: change_param
    return
  )

  $(document).on("change", "#valid_for_box", ->
    valid_for = $('#valid_for_box')
    valid_til = $('#valid_til_box')
    valid_for[0].checked = true
    valid_til[0].checked = false
  )
  $(document).on("change", "#valid_til_box", ->
    valid_for = $('#valid_for_box')
    valid_til = $('#valid_til_box')
    valid_for[0].checked = false
    valid_til[0].checked = true
  )

  $(document).on("click", "#custom_agreement", ->
    theAgreement = $('#custom_agreement')
    theComment = $('#custom_agreement_comment')
    theCommentLabel = $('#custom_agreement_comment_label')
    console.log("found", theAgreement[0].checked)
    if theAgreement[0].checked == true
      theComment[0].hidden = false
      theCommentLabel[0].hidden = false 
    if theAgreement[0].checked == false
      theComment[0].hidden = true
      theCommentLabel[0].hidden = true 
  )
  clickCount = 0  
  $(document).on("click", ".logoutclickcount", -> 
      clickCount++
      console.log("LETS GO!!!!!", clickCount)
      if clickCount == 10
        $.get "/users/sign_out"
  )
