ready = ->
  if $('.top_10_bar').size > 0
    $("div.pagination a").attr('data-remote', 'true') 

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('ajaxComplete', ready)

readynoajax = ->
  if $('.top_10_bar').size > 0
    ajaxPaginate()
    pietop10()
    choosePlayer()

$(document).ready(readynoajax)
$(document).on('page:load', readynoajax)

pietop10 = ->
  options = {
    chart: {
      renderTo:'top10',
      type: 'column'
    },
    title: {
      text: 'Top 10 Players'
    },
    xAxis: {
      categories: ['Points', 'Home', 'Away']
    },
    yAxis: {
      title: {
        text: 'Players'
      },
    },
    series: []    
  }
  options.series = 
    (seriesobj(ply) for ply in $('#top10').data('players'))
  chart = new Highcharts.Chart(options)

seriesobj = (ply) ->
  {
    name: ply.name,
    data: 
      [ply.total_points, ply.cost_start, ply.cost_now]
  }

choosePlayer = ->
  lst = new ChosenList
  $('tbody').on('click', '.person' ,(event) -> 
    event.stopPropagation()
    lst.add({player_id: $(this).children('.player_id').html(),
    player_name: $(this).children('.player_name').html()
    }, this))
  $('tbody').on('mouseenter', '.splayer', (event) ->
    event.stopPropagation()
    if $(this).find('.s_id').val()
      $(this).find('input').addClass('cross')
  )

ajaxPaginate = ->
$('tbody').on("click", ".pagination a", ->
    this.attr('data-remote', 'true')
    jQuery.ajax({ url: this.href })
    return false)

class ChosenList
  constructor: ->
    @chosenlist = []
  add: (ply, clickedperson) ->
    if @playerInList(ply) and @lastInList() <= 9
      @chosenlist.push(ply)
      lastchosen = @lastInList()
      $( clickedperson ).effect( 
        "transfer", { to: $(".splayer" + lastchosen) }, 1000 )
      $(".s_id#{lastchosen}")
        .attr('value', @chosenlist[lastchosen]["player_id"])
      $(".s_name#{lastchosen}")
        .attr('value', @chosenlist[lastchosen]["player_name"])

  lastInList: () =>
    @chosenlist.length - 1

  playerInList: (ply) ->
    for ply1 in @chosenlist 
      if ply1.player_id is ply.player_id then id = ply1.player_id
    !id

  remove: () ->
  initialize: () ->
  reorganize: () ->
  #find the list
  #add delete from list
