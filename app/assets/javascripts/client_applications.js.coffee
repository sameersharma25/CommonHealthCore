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

  $(document).on("click", ".prepare_application", ->
    id = $(this).attr("id")
    console.log("the id of the invite is ", id)
    $.post "/send_application_prep_request",
      id: id
    return
  )

  $('#notification_rules').DataTable();


  $('#user_list').DataTable({ responsive: true });

  $('#client_application').DataTable( );

  $('#contact_management_table').DataTable({
   "pagingType": "input",
   "sDom": '<"top"<"actions">lfpi<"clear">><"clear">rt<"bottom">'
  }

  );

  $('#master_catalog').DataTable();


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


    
  #send for approval onclick js
  $(document).on("click", ".sendForApprovals", ->
    row_id = $(this).attr("id")
    console.log("THAT's MY BUTTON", row_id)
    url = $('#url_' + row_id).text()
    orgName = $('#nameOfOrg_' + row_id).text()
    console.log("THAT's MY BUTTON", url, orgName)
    cRow = $('#rule_' + row_id).text()
    console.log("WHAT IS CrOW", cRow)
    $.post "/send_for_approval",
      row_id: row_id
      orgName: orgName
      url: url
      cRow: cRow
      console.log("inside post")
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

  $(document).on("click", ".collectButton", ->
    console.log("collect button clicked Coffee****")
    id = this.id
    console.log("COLLECTION BUTTON ID ", id)
    `var i`
    `var inputElement`
    `var i`
    `var inputElement`
    `var i`
    `var inputElement`
    `var i`
    `var inputElement`
    `var i`
    `var i`
    `var inputElement`
    `var i`
    `var i`
    `var inputElement`
    `var i`
    `var i`
    `var inputElement`
    `var i`
    `var q`
    `var inputElement`
    `var q`
    `var k`
    `var inputElement`
    `var q`
    `var k`
    `var inputElement`
    `var q`
    `var k`
    `var inputElement`
    organizationDetails = {}
    #OrgForm //Need to ignore certain values
    orgform = document.getElementById('OrgForm')
    inputElements = orgform.querySelectorAll('input, textarea')
    organizationName = {}
    i = 0
    while i < inputElements.length
      inputElement = inputElements[i]
      if inputElement.value == ''
        console.log 'skip'
      else if inputElement.type == 'checkbox' and inputElement.checked == true
        organizationName[inputElement.name] = true
      else if inputElement.type == 'checkbox' and inputElement.checked != true
        organizationName[inputElement.name] = false
      else if inputElement.name == 'Text' or inputElement.name == 'Xpath' or inputElement.name == 'Domain' or inputElement.name == 'authenticity_token' or inputElement.name == 'utf8'
        console.log 'skip'
      else
        organizationName[inputElement.name] = inputElement.value
      i++
    #orgName
    orgName = document.getElementById('orgName')
    orgNameElements = orgName.querySelectorAll('input')
    nameObj = {}
    i = 0
    while i < orgNameElements.length
      inputElement = orgNameElements[i]
      if inputElement.value == ''
        console.log 'skip'
      else
        nameObj[inputElement.name] = inputElement.value
      console.log inputElement.name, '=', inputElement.value
      i++
    nameArray = []
    nameArray.push nameObj
    organizationName['OrganizationName'] = nameArray
    #orgDesc
    orgDesc = document.querySelectorAll('.orgDescription:not(.hidden)')
    orgDescArray = []
    i = 0
    while i < orgDesc.length
      orgDescElements = orgDesc[i].querySelectorAll('input')
      descObj = {}
      q = 0
      while q < orgDescElements.length
        inputElement = orgDescElements[q]
        if inputElement.value == ''
          console.log 'skip'
        else
          descObj[inputElement.name] = inputElement.value
        console.log inputElement.name, '=', inputElement.value
        q++
      orgDescArray.push descObj
      i++
    if orgDescArray.length > 0
      organizationName['OrgDescription'] = orgDescArray
    #//
    organizationDetails['OrganizationName'] = organizationName
    #///////
    console.log 'After Org', organizationDetails
    # Geo
    geoHash = {}
    geoform = document.getElementById('GeoScopeForm')
    geoinputElements = geoform.querySelectorAll('input')
    i = 0
    while i < geoinputElements.length
      inputElement = geoinputElements[i]
      if inputElement.value == ''
        console.log 'skip'
      else if inputElement.name == 'Text' or inputElement.name == 'Xpath' or inputElement.name == 'Domain' or inputElement.name == 'authenticity_token' or inputElement.name == 'utf8'
        console.log 'skip'
      else
        geoHash[inputElement.name] = inputElement.value
      i++
    organizationDetails['GeoScope'] = geoHash
    #/ End Geo
    #/ Site Form
    siteForm = document.getElementsByClassName('SiteForm')
    orgSiteArray = []
    k = 0
    while k < siteForm.length
      siteHash = {}
      siteinputElements = siteForm[k].querySelectorAll('input')
      i = 0
      while i < siteinputElements.length
        inputElement = siteinputElements[i]
        if inputElement.value == ''
          console.log 'skip'
        else if inputElement.type == 'checkbox' and inputElement.checked == true
          siteHash[inputElement.name] = true
        else if inputElement.type == 'checkbox' and inputElement.checked != true
          siteHash[inputElement.name] = false
        else if inputElement.name == 'Text' or inputElement.name == 'Xpath' or inputElement.name == 'Domain' or inputElement.name == 'authenticity_token' or inputElement.name == 'utf8' or inputElement.name == 'id'
          console.log 'skip'
        else
          siteHash[inputElement.name] = inputElement.value
        i++
      #inside loop #1
      pocSArray = []
      sitepoc = siteForm[k].getElementsByClassName('sitePOC')
      i = 0
      while i < sitepoc.length
        singlePOC = {}
        pocpoc = {}
        sitepocinput = sitepoc[i].querySelectorAll('input')
        i = 0
        while i < sitepocinput.length
          inputElement = sitepocinput[i]
          if inputElement.value == ''
            console.log 'skip'
          else if inputElement.type == 'checkbox' and inputElement.checked == true
            singlePOC[inputElement.name] = true
          else if inputElement.type == 'checkbox' and inputElement.checked != true
            singlePOC[inputElement.name] = false
          else if inputElement.name == 'id'
            pocpoc['id'] = inputElement.value
          else
            singlePOC[inputElement.name] = inputElement.value
          i++
        pocpoc['poc'] = singlePOC
        pocSArray.push pocpoc
        siteHash['POCs'] = pocSArray
        i++
      #
      siterefArray = []
      siteref = siteForm[k].getElementsByClassName('siteSiteReference')
      i = 0
      while i < siteref.length
        siterefHash = {}
        siterefinput = siteref[i].querySelectorAll('input')
        i = 0
        while i < siterefinput.length
          inputElement = siterefinput[i]
          if inputElement.value == ''
            console.log 'skip'
          else
            siterefHash[inputElement.name] = inputElement.value
          i++
        siterefArray.push siterefHash
        siteHash['SiteReference'] = siterefArray
        i++
      addr1array = []
      siteAddr1 = siteForm[k].getElementsByClassName('siteAddr1')
      i = 0
      while i < siteAddr1.length
        addr1 = {}
        addInput = siteAddr1[i].querySelectorAll('input')
        i = 0
        while i < addInput.length
          inputElement = addInput[i]
          if inputElement.value == ''
            console.log 'skip'
          else
            addr1[inputElement.name] = inputElement.value
          i++
        addr1array.push addr1
        siteHash['Addr1'] = addr1array
        i++
      #
      orgSiteArray.push siteHash
      k++
    # End Site Loop
    organizationDetails['OrgSites'] = orgSiteArray
    #End Site Form
    #Program
    programform = document.getElementsByClassName('ProgramForm')
    programsArray = []
    i = 0
    while i < programform.length
      programHash = {}
      #basic elements
      progrraminputElements = programform[i].querySelectorAll('input, textarea')
      q = 0
      while q < progrraminputElements.length
        inputElement = progrraminputElements[q]
        if inputElement.value == ''
          console.log 'skip'
        else if inputElement.type == 'checkbox' and inputElement.checked == true
          programHash[inputElement.name] = true
        else if inputElement.type == 'checkbox' and inputElement.checked != true
          programHash[inputElement.name] = false
        else if inputElement.name == 'Text' or inputElement.name == 'Xpath' or inputElement.name == 'Domain' or inputElement.name == 'authenticity_token' or inputElement.name == 'utf8'
          console.log 'skip'
        else if inputElement.name == 'ProgramSites'
          programSiteArray = []
          programSiteArray.push inputElement.value
          programHash['ProgramSites'] = programSiteArray
        else
          programHash[inputElement.name] = inputElement.value
        q++
      #PopDesc
      popDescArray = []
      programPopDecs = programform[i].getElementsByClassName('programPopulationDescription')
      q = 0
      while q < programPopDecs.length
        popDescHash = {}
        popDescinputElements = programPopDecs[q].querySelectorAll('input')
        k = 0
        while k < popDescinputElements.length
          inputElement = popDescinputElements[k]
          if inputElement.value == ''
            console.log 'skip'
          else
            popDescHash[inputElement.name] = inputElement.value
          k++
        popDescArray.push popDescHash
        programHash['PopulationDescription'] = popDescArray
        q++
      #Program Description
      progDescArray = []
      programProgDesc = programform[i].getElementsByClassName('programProgramDescription')
      q = 0
      while q < programProgDesc.length
        progDescHash = {}
        progDescinputElements = programProgDesc[q].querySelectorAll('input')
        k = 0
        while k < progDescinputElements.length
          inputElement = progDescinputElements[k]
          if inputElement.value == ''
            console.log 'skip'
          else
            progDescHash[inputElement.name] = inputElement.value
          k++
        progDescArray.push progDescHash
        programHash['ProgramDescription'] = progDescArray
        q++
      # program Service area
      serviceAreaArray = []
      programServiceArea = programform[i].getElementsByClassName('programServiceAreaDescription')
      q = 0
      while q < programServiceArea.length
        serviceAreaHash = {}
        progServAinputElements = programServiceArea[q].querySelectorAll('input')
        k = 0
        while k < progServAinputElements.length
          inputElement = progServAinputElements[k]
          if inputElement.value == ''
            console.log 'skip'
          else
            serviceAreaHash[inputElement.name] = inputElement.value
          k++
        serviceAreaArray.push serviceAreaHash
        programHash['ServiceAreaDescription'] = serviceAreaArray
        q++
      programsArray.push programHash
      i++
    #End of Program Loop
    organizationDetails['Programs'] = programsArray
    organizationDetails['url'] = document.getElementById('theurl').innerText
    #submitChange organizationDetails
    #return

    if id == 'add_sites'
      crud = JSON.stringify(organizationDetails)
      console.log("INSIDE THIS CRUD", crud)
      $.post "/new_site_adding",
      catalog_data: crud
      return

    else if id == 'add_programs'
      console.log("INSIDE SUBMIT PROGRAM")
      crud = JSON.stringify(organizationDetails)
      $.post "/new_program_adding",
        program_data: crud
      return
  )
