class Player < ActiveRecord::Base
	belongs_to :club
	has_many :player_histories

	scope :venue_split, ->(player_id) do 
		where("players.id in (?)", player_id)
		.joins("INNER JOIN player_histories ON player_histories.player_id = players.id
			INNER JOIN clubs ON clubs.id = players.club_id")
		.select("players.id, players.name as web_name, clubs.name as club, players.total_points, 
			venue, count(1) as games, sum(points) as points")
		.group("players.id,player_histories.venue, clubs.name") 
	end
	scope :stats, ->(fstround = 1, lstround= 38) do
		where("ph.round >= (?) and ph.round <= (?)",fstround,lstround)
		.joins("as p INNER JOIN player_histories as ph ON ph.player_id = p.id
			INNER JOIN clubs on clubs.id = p.club_id")
		.select("p.id as id,p.name as name, p.position, 
			round(p.cost_now,1)/10 as cost_now,
			sum(ph.points) as points, 
			round(sum(round(ph.points*10, 2)/round(ph.value,2)),2) as range_value,
			sum(ph.miniutes_played) as miniutes_played, 
			sum(ph.goals_scored) as goals_scored, 
			sum(ph.assists) as assists, 
			sum(ph.clean_sheets) as clean_sheets, 
			sum(ph.goals_conceded) as goals_conceded, 
			sum(ph.own_goals) as own_goals, 
			sum(ph.penalty_saves) as penalty_saves, 
			sum(ph.penalty_missed) as penalty_missed, 
			sum(ph.yellow_cards) as yellow_cards, 
			sum(ph.red_cards) as red_cards, 
			sum(ph.saves) as saves, 
			sum(ph.bonus) as bonus, 
			sum(ph.esp) as esp, 
			sum(ph.net_transfers) as net_transfers,
			round(sum(round(ph.miniutes_played,2)/80)) as games,
			round(sum(case  
				when ph.miniutes_played > 0 then round(ph.points,3)/ph.miniutes_played
				else 0
				end),2) as points_per_min,
			round(case when sum(ph.points) > 0 then
				round(sum(ph.points),2)/
						sum(case
							when ph.miniutes_played > 0 then 1
							else 0
			 			end)
					else 0 end,2) as points_per_game,
			clubs.name as clubname")
		.group("p.id, p.position, p.cost_now, clubs.name")
	end
	scope :by_name, ->(name) do
		where("players.name = (?)", name)
	end
end
