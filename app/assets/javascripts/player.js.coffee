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
		$('.statsHeader th i').replaceWith(-> $(this).contents())
	add : (stat)->
		order = {name : stat, direction : 'DESC'}
		@arrow(order)
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
		@arrow(order)
		order.direction
	arrow : (order)->
		if order.direction is 'DESC'
			$('.statsHeader th.' + order.name).html("<i class='fa fa-arrow-circle-down fa-fw'></i>" + $('.statsHeader th.' + order.name).text())
		else
			$('.statsHeader th.' + order.name).html("<i class='fa fa-arrow-circle-up fa-fw'></i>" + $('.statsHeader th.' + order.name).text())