# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  console.log("Client Application Coffee****")
  $('#notification_rules').DataTable();

  $('#user_list').DataTable({ responsive: true });

  $('#client_application').DataTable( );