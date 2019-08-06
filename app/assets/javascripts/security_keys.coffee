# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


	#Pii
  $(document).on("click", "#pii_button", ->
  		theDiv = $('.berkley') 
  		keyName = $('#keyName').val()
  		console.log("ket name",keyName)
  		keyValues = []
  		theDiv.each (x) ->
  			console.log("alive", theDiv[x])
  			if theDiv[x].checked == true
  				keyValues.push(theDiv[x].id)
  		console.log("my array",keyValues)
  		$.post "/security_keys",
	      key_name: keyName,
	      key_value: keyValues,
	      key_type: 'pii'
    ) 
    #Phi
  $(document).on("click", "#phi_button", ->
  		theDiv = $('.berkley') 
  		keyName = $('#keyName').val()
  		console.log("ket name",keyName)
  		keyValues = []
  		theDiv.each (x) ->
  			console.log("alive", theDiv[x])
  			if theDiv[x].checked == true
  				keyValues.push(theDiv[x].id)
  		console.log("my array",keyValues)
  		$.post "/security_keys",
	      key_name: keyName,
	      key_value: keyValues,
	      key_type: 'phi'
    ) 
    #Sad
  $(document).on("click", "#sad_button", ->
  		theDiv = $('.berkley') 
  		keyName = $('#keyName').val()
  		console.log("ket name",keyName)
  		keyValues = []
  		theDiv.each (x) ->
  			console.log("alive", theDiv[x])
  			if theDiv[x].checked == true
  				keyValues.push(theDiv[x].id)
  		console.log("my array",keyValues)
  		$.post "/security_keys",
	      key_name: keyName,
	      key_value: keyValues,
	      key_type: 'sad'
    ) 
  $(document).on("click", ".delete", -> 
   		row_id = $(this).attr('id')
   		id = row_id.split('_')[1]
   		row = $('#key_' + id)
   		keyName = row[0].cells[0].innerText
   		console.log("Look", keyName, 'length',keyName.length)
   		$.post "/delete_keys",
   			key_name: keyName
   )
  $(document).on("click", ".edit", -> 
   		row_id = $(this).attr('id')
   		id = row_id.split('_')[1]
   		row = $('#key_' + id)
   		keyName = row[0].cells[0].innerText
   		console.log("Look", keyName, 'length',keyName.length)
   		$.post "/update_keys",
   			key_name: keyName

   )
