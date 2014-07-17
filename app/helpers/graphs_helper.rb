module GraphsHelper
	def playerdata
		Player.order(total_points: :desc).limit(10)
	end
end
