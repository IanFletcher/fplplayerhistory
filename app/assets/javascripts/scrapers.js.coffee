# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
  $('#flash_notice, #ajaxmessage').show().delay(5000).slideUp('slow', 'swing')
  ajaxanimation()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('ajaxComplete', ready)


ajaxanimation = ->
  $('.scrapeform')
    .on('ajax:beforeSend', (event, xhr, settings) -> 
    	$('.soccerball').show())
    .on('ajax:complete', (event, xhr, status) -> 
    	$('.soccerball').hide())
