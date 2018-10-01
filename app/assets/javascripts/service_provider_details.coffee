# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).on("click", ".internal_data_storage, .external_data_storage", ->
#    console.log($(this).val())
    value = $(this).val()
    if value is "External"
      $(".service_provider_api").removeClass("hide")
      $(".upload_csv").addClass("hide")
    else if value is "Internal"
      $(".service_provider_api").addClass("hide")
      $(".upload_csv").removeClass("hide")
  )