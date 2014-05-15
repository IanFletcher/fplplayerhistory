class GraphsController < ApplicationController
	def top_10_bar
		@data = Player.order(total_points: :desc).limit(10)
		logger.debug  Player.venue_split([214, 100]).inspect
		@players = Player.paginate(:per_page => 10, :page => params[:page] || 1)
	end
end
