class GraphsController < ApplicationController
	def top_10_bar
		aj = if params[:aj]
			params[:aj]
		else
			false
		end
	#	@data = Player.order(total_points: :desc).limit(10) unless aj
#		x= Player.venue_split([214, 100])
		# logger.debug  x[0].web_name
		# logger.debug  x[1].web_name
		# logger.debug  x.size
		@players = Player.paginate(:per_page => 10, :page => params[:page] || 1)
		respond_to do |format|
			format.html
			format.js { render layout: false }
		end
	end
end
