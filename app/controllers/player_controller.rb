class PlayerController < ApplicationController
	def comparison
		@players = Player.stats
	end
	def filter
	#	if params[:venue]
		@players = Player.stats
		condition("ph.venue = '#{params[:venue]}'") if has_venue
	#	end
		condition("p.position = '#{params[:position]}'") if has_position
		if params[:player_order]
			orders = params[:player_order].split(',')
			if orders.size > 2
				orders = orders.each_slice(orders.size/2).to_a
			else
				orders = [orders]
			end
			orders = orders.map{|order| order.join(" ")}.join(",")
		end
	#	@players = Player.stats
		@players = @players.order(orders) 	if defined?(orders)
	#	@players = @players.where(extra_where) if defined?(extra_where)
	end

	def has_venue
		['H','A'].include? params[:venue]
	end
	def has_position
		['G','D','M','F'].include? params[:position] 
	end
	def condition(cond)
		@players = @players.where(cond)
	end
end
