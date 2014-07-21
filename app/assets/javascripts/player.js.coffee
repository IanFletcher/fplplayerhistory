# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	if $('.playerComparison').length > 0
#  	cloneHeader()
#		check()
		frozenhead()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('ajaxComplete', ready)



headerCellWidth = ->
	widthArray = []
	$('.playerTable th').each(-> 
		widthArray.push $(this).width())
	#	widthArray.push $(this).text())
#	alert(widthArray)
#	$('.fixedHeader thead').eq(0).find('th').each((index, element)->
#		$(element).css('width': 1))	
	$('.fixedHeader thead').eq(0).find('th').each((index, element)->
		$(element).css('width': widthArray[index]))
#	$('tr').eq(1).find('td').each((index, element)->
#		$(element).css('width', widthArray[index]))

headerTheadWidth = ->
	alert('header')
	width = $('.playerTable thead').width()
	alert('width is ' + width)
	$('.fixedHeader thead').eq(0).css('width': width)

cloneHeader = ->
	cpy = $('thead').clone(true)
	$(cpy).prependTo('.fixedHeader')
	alert('here')
	$('.fixHeader thead').eq(0).find('tr').append("<th></th>")
#	headerTheadWidth()
	headerCellWidth()
#	$('.playerTable thead').hide()

check = ->
	$('.fixedHeader').on('click', -> 
		widthArray = []
		$('.playerTable th').each(-> 
			widthArray.push $(this).width()
			widthArray.push $(this).text())
		alert(widthArray))

frozenhead = ->
	$(document).scroll(->
		delta = $(window).scrollTop() - $(".playerTable thead").offset().top
		if delta > 0
			translate($(".playerTable th"),0,delta-2)
		else
			translate($(".playerTable th"),0,0))

translate = (element, x, y) ->
	    translation = "translate(" + x + "px," + y + "px)"
	    element.css(
	        "transform": translation,
	        "-ms-transform": translation,
	        "-webkit-transform": translation,
	        "-o-transform": translation,
	        "-moz-transform": translation)