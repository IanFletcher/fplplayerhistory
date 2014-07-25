# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	if $('.playerComparison').length > 0
		frozenhead()
readynoajax = ->
	if $('.playerComparison').length > 0
		setupSubmit()

$(document).ready(
	readynoajax
	ready)
$(document).on('page:load', 
	readynoajax
	ready)
$(document).on('ajaxComplete', ready)

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

setupSubmit = ->
	$('.submitAlias').off()
	$('.submitAlias').off('th')
	$('.submitFilter').hide()
	$('.submitAlias').on('click', ->
		$('.player_order').val(orderBy.makeArray())
		$('.submitFilter').click()
	)
	$('th').on('click', (e)->
		orderBy.combination(e, $(this).attr('class'))
		$('.player_order').val(orderBy.makeArray())
		$('.submitFilter').click()
		e.stopPropagation()
	)

orderBy =
	orders : []
	ordersArray : []
	makeArray : ->
		@ordersArray = []
		for order in @orders
			for k, v of order
				@ordersArray.push v
		@ordersArray
	combination : (e, stat) ->
		if e.shiftKey
			@update(stat)
		else
			unless @check(stat)
				@remove() 
				@add(stat)
	remove : ->
		@orders = []
	add : (stat)->
		order = {name : stat, direction : 'DESC'}
		@orders.push order
	update: (stat)->
		unless @check(stat)
			@add(stat)
	check : (stat)->
		changed = false
		for row in @orders
			if row.name == stat
  			row.direction = @changeDirection(row)
  			changed = true
		changed
	changeDirection : (order) ->
		if order.direction == 'ASC'
			order.direction = "DESC"
		else
			order.direction = 'ASC'

