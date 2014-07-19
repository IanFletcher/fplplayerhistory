class PlayerController < ApplicationController
	def comparison
		@players = Player.stats
	end
end
