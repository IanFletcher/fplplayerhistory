class PlayerController < ApplicationController
	def comparison
		@players = Player.stats
	end
	def filter
		if params[:player_order]
			orders = params[:player_order].split(',')
			if orders.size > 2
				orders = orders.each_slice(orders.size/2).to_a
			else
				orders = [orders]
			end
			orders = orders.map{|order| order.join(" ")}.join(",")
			@players = Player.stats.order(orders)
		end
	end
end
