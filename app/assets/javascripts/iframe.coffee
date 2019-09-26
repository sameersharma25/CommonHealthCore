jQuery ($) ->
  $(document).on("click", "#thirtythree", ->
    console.log("chitty chitty bang bang")
    sayHello()
  )

sayHello = ->
		$.ajax({
		type: 'DELETE',
		url: 'users/sign_out'
		});




