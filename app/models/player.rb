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
	scope :stats, ->(fstround, lstround) do
		where("player_histories.round >= (?) and player_histories.round <= (?)",fstround,lstround)
		.joins(:player_histories)
		.select("players.id as id,players.name as name, 
			sum(player_histories.points) as points, 
			sum(player_histories.miniutes_played) as miniutes_played, 
			sum(player_histories.goals_scored) as goals_scored, 
			sum(player_histories.assists) as assists, 
			sum(player_histories.clean_sheets) as clean_sheets, 
			sum(player_histories.goals_conceded) as goals_conceded, 
			sum(player_histories.own_goals) as own_goals, 
			sum(player_histories.penalty_saves) as penalty_saves, 
			sum(player_histories.penalty_missed) as penalty_missed, 
			sum(player_histories.yellow_cards) as yellow_cards, 
			sum(player_histories.red_cards) as red_cards, 
			sum(player_histories.saves) as saves, 
			sum(player_histories.bonus) as bonus, 
			sum(player_histories.esp) as esp, 
			sum(player_histories.net_transfers) as net_transfers")
		.group("players.id")
	end
	scope :by_name, ->(name) do
		where("players.name = (?)", name)
	end
end


#players = Player.all.joins(:player_histories).select("players.id as id,players.name as name, sum(player_histories.points) as points, sum(player_histories.miniutes_played) as miniutes_played, sum(player_histories.goals_scored) as goals_scored, sum(player_histories.assists) as assists, sum(player_histories.clean_sheets) as clean_sheets, sum(player_histories.goals_conceded) as goals_conceded, sum(player_histories.own_goals) as own_goals, sum(player_histories.penalty_saves) as penalty_saves, sum(player_histories.penalty_missed) as penalty_missed, sum(player_histories.yellow_cards) as yellow_cards, sum(player_histories.red_cards) as red_cards, sum(player_histories.saves) as saves, sum(player_histories.bonus) as bonus, sum(player_histories.esp) as esp, sum(player_histories.net_transfers) as net_transfers").group("players.id")


