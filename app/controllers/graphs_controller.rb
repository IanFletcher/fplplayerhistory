class GraphsController < ApplicationController
	def top_10_bar
		@data = Player.order(total_points: :desc).limit(10)
	#	PlayerHistory.find_by(player_id: @data.pluck[:id]).group(:venue).select(:total_points, :venue, :player_id).sum(:total_points)
	end
end
