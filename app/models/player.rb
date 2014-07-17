class Player < ActiveRecord::Base
	has_one :club
	has_many :player_histories

	scope :venue_split, ->(player_id) do 
		where("players.id in (?)", player_id)
		.joins("INNER JOIN player_histories ON player_histories.player_id = players.id
			INNER JOIN clubs ON clubs.id = players.club_id")
		.select("players.id, players.name as web_name, clubs.name as club, players.total_points, 
			venue, count(1) as games, sum(points) as points")
		.group("players.id,player_histories.venue, clubs.name") 
	end
end
