# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->

  parse_id = (attr_val) ->
    row_id = attr_val.split("_")[1]



  $(document).on("click", ".validate_rules", ->
    ids_hash = get_catalogue_ids()
#    checkbox_elemenet = $(".catalogue_checkboxes")
#    cat_ids = []
#    checkbox_elemenet.each (index, element) ->
#      console.log(" is: " + $(this).is(':checked'))
#      if $(this).is(':checked')
#        console.log($(this).val())
#        cat_ids.push(element.value)
    console.log("the array of the cat ids is: ", ids_hash["row_ids"])
    $.post "/validate_cat_entry",
      ids: ids_hash["cat_ids"],
      row_ids: ids_hash["row_ids"]
    return

  )

  $(document).on("click", ".remove_rules", ->
    ids_hash = get_catalogue_ids()
    console.log("the id hash is : ", ids_hash["row_ids"])
    $.post "/remove_cat_entry",
      ids: ids_hash["cat_ids"],
      row_ids: ids_hash["row_ids"]
    return
  )

  get_catalogue_ids = ->
    checkbox_elemenet = $(".catalogue_checkboxes")
    cat_ids = []
    row_ids = []
    checkbox_elemenet.each (index, element) ->
      console.log(" is: " + $(this).is(':checked'))
      if $(this).is(':checked')
        console.log($(this).val())
        row_id = $(this).attr("id")
        cat_ids.push(element.value)
        row_ids.push(row_id)
#    console.log("the array of the cat ids is: ", cat_ids)
    cat_ids
    return {row_ids: row_ids, cat_ids: cat_ids }
