class PlayerController < ApplicationController
	def comparison
		@players = Player.stats
	end
	def filter
		if params[:venue]
			extra_where = "ph.venue = '#{params[:venue]}'" if params[:venue] == 'H' or params[:venue] =='A'
		end
		if params[:player_order]
			orders = params[:player_order].split(',')
			if orders.size > 2
				orders = orders.each_slice(orders.size/2).to_a
			else
				orders = [orders]
			end
			orders = orders.map{|order| order.join(" ")}.join(",")
		end
		@players = Player.stats
		@players = @players.order(orders) 	if defined?(orders)
		@players = @players.where(extra_where) if defined?(extra_where)
	end
end
