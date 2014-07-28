$('.scrollingBody')
	.empty()
	.append($("<%= escape_javascript(render partial: "player", locals: { players: @players}) %>"))
	.animate({'color': "black" }, 1000, function(){});
