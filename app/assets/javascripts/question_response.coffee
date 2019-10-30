# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
console.log("in the questions response coffeee")
jQuery ($) ->
  $(document).on("click", ".next_question", ->
    console.log("in the questions response coffeee")
    selValue = $('input[type=radio]:checked').val();
    cus_id = $("#client_application_id").val()
    ques_id = $("#question_id").val()
#    console.log("the value of the radio button is :" + selValue + "Customer ID is : "+ cus_id+ "---------"+ ques_id)
    $.post "/backend/next_question",
      answer: selValue,
      cus_id: cus_id,
      ques_id: ques_id
    return

  )

  $(document).on("click", ".skip_survey", ->
    cus_id = $("#client_application_id").val()
    $.post "/backend/skip_survey",
      cus_id: cus_id
    return
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
