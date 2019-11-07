# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


  $(document).on("keyup", "#application_name", ->
    appName = $('#application_name').val() 
    console.log("appName::", appName)
    appURL = $('#application_url')
    console.log("appURL", appURL)
    appURL[0].value = appName + '.commonhealthcore.com'
    )

