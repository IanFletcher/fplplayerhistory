ready = ->
  pietop10()
  ajaxpaginate()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('ajaxComplete', ready)

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


ajaxpaginate ->
 jQuery("div.pagination a").click(->
    jQuery.ajax({ url: this.href })
    return false)

