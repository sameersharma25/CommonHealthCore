# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->

  parse_id = (attr_val) ->
    row_id = attr_val.split("_")[1]

  $(document).on("click", ".add_rule", ->
    console.log("in the add rule function")
    row_id = $(this).attr("id")
    id = parse_id(row_id)
    console.log("the row id is: ", id)
    description = $("#Orgdescription_" + id).text()
    description_xpath = $("#Orgdescription_xpath_" + id).attr("name")
    description_url = $("#Orgdescription_url_" + id).attr("name")
    orgName = $("#nameOfOrg_" + id).text()
    orgName_xpath = $("#orgName_xpath_" + id).attr("name")
    orgName_url = $("#orgName_url_" + id).attr("name")
    url = $("#url_" + id).attr("name")
    console.log("the description is: ", description, "name of the org is : ", orgName, "desc xpath: ",description_xpath, "desc URL : ", description_url,"url :", url )

    $.post "/manage_scraping_rules",
      row_id: id,
      url: url,
      description: description,
      description_xpath: description_xpath,
      description_url: description_url,
      org_name: orgName,
      orgName_xpath: orgName_xpath,
      orgName_url: orgName_url
    return
  )

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
