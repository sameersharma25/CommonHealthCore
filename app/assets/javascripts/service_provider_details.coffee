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
  $('[data-toggle="tooltip"]').tooltip()

#  $(document).on("change", "#filter_field_type", ->
#    console.log($(this).val())
#    value = $(this).val()
#    $.post "/filter_field_values",
#      field_type: value
#    return
#  )

  $(document).on("click", ".add_filter_fields", ->
    name = $("#field_name").val()
    values = $("#filter_field_values").val()
    type = $("#filter_field_type").val()
    $("#field_name").val('')
    $("#filter_field_values").val('')
    console.log(name + values + type )
    $.post "/backend/add_filter_fields",
      name: name,
      values: values,
      type: type
    return
  )
  $(document).on("click", ".provider_filter", ->
    filter_value = $(this).val("id")[0].id
    console.log(filter_value)
    $.get "/backend/filter_page",
      filter: filter_value
    return
  )

  $("#service_provider_details_tables").DataTable()