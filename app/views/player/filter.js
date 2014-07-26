$('.scrollingBody').empty()
$('.scrollingBody').append($("<%= escape_javascript(render partial: "player", locals: { players: @players}) %>"))