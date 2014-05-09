# http://fantasy.premierleague.com/web/api/elements/214/
# /web/api/elements/214/
#require "watir-webdriver"

class ScrapePlayerHistory
	require "nokogiri"
	require 'open-uri'
	require 'json'

	def initialize(full_scrape)
		@player_attr = 
		  {:web_name => :name, :first_name => :firstname, :second_name => :surname}
		player_iterator
	end
	def player_iterator
		player = nil
		fplplayer_id = 1
		while player || fplplayer_id == 1 do
			player = webcontent(fplplayer_id)
			player_id = extract(player , fplplayer_id)
			extract_history(player, player_id) if player_id
			fplplayer_id += 1
			player = nil if fplplayer_id == 10 
		end
	end
	def extract(player, fplplayer_id)
		new_player = {:fplplayer_id => fplplayer_id}
		 @player_attr.keys.each do |att|
			new_player[@player_attr[att]] = player[att.to_s]
		end
		new_player[:club_id] = club_check(player["team_name"])
		create_player(new_player)
	end
	def create_player(new_player)
		ply = Player.create(new_player)
		ply.id
	end
	def webcontent(fplplayer_id)
		JSON.parse(
			open("http://fantasy.premierleague.com/web/api/elements/#{fplplayer_id.to_s}/").read)
	end
	def club_check(name)
		club = @clbs.select { |clb| clb if clb.name == name }[0] if @clbs
		club = new_club(name) unless club
		club.id
	end
	def new_club(name)
		club = Club.create(name: name)
		@clbs = Club.all
		club			
	end
	def extract_history(player, player_id)
		gamehistory = []
		player["fixture_history"]["all"].each do |sched|
			playerhistory = {:player_id => player_id}
			playerhistory[:gamedate] = DateTime.strptime(sched[0], '%d %b %H:%M')
			playerhistory[:round] = sched[1]
			game = sched[2].match(/(\w+)\((\w)\)\s(\d+)-(\d+)/)
			playerhistory[:opponent] = game[1]
			playerhistory[:venue] = game[2]
			if playerhistory[:venue] == 'h'
				playerhistory[:club_score] = game[3].to_i
				playerhistory[:opposition_score] = game[4].to_i
			else
				playerhistory[:opposition_score] = game[3].to_i
				playerhistory[:club_score] = game[4].to_i
			end
			playerhistory[:miniutes_played] = sched[3]
			playerhistory[:goals_scored] = sched[4]
			playerhistory[:assists] = sched[5]
			playerhistory[:clean_sheets] = sched[6]
			playerhistory[:goals_conceded] = sched[7]
			playerhistory[:own_goals] = sched[8]
			playerhistory[:penalty_saves] = sched[9]
			playerhistory[:penalty_missed] = sched[10]
			playerhistory[:yellow_cards] = sched[11]
			playerhistory[:red_cards] = sched[12]
			playerhistory[:saves] = sched[13]
			playerhistory[:bonus] = sched[14]
			playerhistory[:esp] = sched[15]
			playerhistory[:bps] = sched[16]
			playerhistory[:net_transfers] = sched[17]
			playerhistory[:value] = sched[18]
			playerhistory[:points] = sched[19]
			gamehistory <<playerhistory
		end
		create_player_history(gamehistory)
		gamehistory
	end
	def create_player_history(plyhist)
		PlayerHistory.create(plyhist)
	end
end
