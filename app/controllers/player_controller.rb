class PlayerController < ApplicationController
	def comparison
		@players = Player.stats
	end
	def filter
		@players = Player.stats(params[:rounds_from].to_i, params[:rounds_to].to_i)
		@players = @players.where("p.cost_now >= (?) and p.cost_now <= (?)", 
			(params[:price_from].to_f*10), (params[:price_to].to_f*10))
		condition("ph.venue = '#{params[:venue]}'") if has_venue
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
		@players = @players.where("p.name ILIKE ?", "%#{params[:search]}%") if has_search
		@players = @players.order(orders) 	if defined?(orders)
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
	def has_search
		params[:search] != ""
	end
end
