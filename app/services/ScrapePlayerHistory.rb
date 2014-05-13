# http://fantasy.premierleague.com/web/api/elements/214/
# /web/api/elements/214/
#require "watir-webdriver"

class ScrapePlayerHistory
	require "nokogiri"
	require 'open-uri'
	require 'json'

	def initialize(full_scrape, scraper)
		@scraper = scraper
		@current_round = 0
		@full_scrape = full_scrape
		all_clubs
	end
	def start
		starttime = DateTime.now
		if @full_scrape
			refresh_database
			player_iterator
		else
			next_fplplayer_id = player_updater
			player_iterator(next_fplplayer_id)
		end
		update_scraper(starttime)
	end
	def update_scraper(starttime)
		@scraper.times_run |= 0
		@scraper.times_run += 1
		@scraper.number_of_players = Player.count
		@scraper.duration = ((DateTime.now - starttime) * 24 * 60 * 60).to_i
		@scraper.save
	end
	def refresh_database
		player_list = Player.where(:season => @scraper.season).pluck(:id)
		PlayerHistory.destroy_all(player_id: player_list)
		Player.destroy_all(id: player_list)
	end
	def player_iterator(fplplayer_id = 1)
		player = nil
		while player || fplplayer_id == 1 do
			player = webcontent(fplplayer_id)
			if player
				player_id = extract_player(player , fplplayer_id) 
				extract_history(player, player_id, 0) if player_id
		#		player = nil if fplplayer_id == 10
			end
			fplplayer_id += 1
		end
	end
	def player_updater
		next_fplplayer_id = 0
		player_list = Player.where(:season => @scraper.season).pluck(:id, :fplplayer_id)
		player_list.each do |ply_id, fplplayer_id|
			player = webcontent(fplplayer_id)
			extract_history(player, ply_id, get_current_round(ply_id))
			next_fplplayer_id = fplplayer_id if fplplayer_id > next_fplplayer_id	
		end
		next_fplplayer_id + 1
	end
	def extract_player(player, fplplayer_id)
		new_player = {:fplplayer_id => fplplayer_id, :season => @scraper.season}
		player_attr.keys.each do |att|
			new_player[player_attr[att]] = player[att.to_s]
		end
		new_player[:club_id] = club_check(player["team_name"])
		new_player[:position] = slice_position(player["type_name"])
		create_player(new_player)
	end
	def create_player(new_player)
		ply = Player.create(new_player)
		ply.id
	end
	def slice_position(position)
		position[1]
	end
	def webcontent(fplplayer_id)
		begin
			JSON.parse(
				open("http://fantasy.premierleague.com/web/api/elements/#{fplplayer_id.to_s}/").read)
			rescue OpenURI::HTTPError => e
				false
		end
	end
	def club_check(name)
		club = @clbs.select { |clb| clb if clb.name == name }[0] if @clbs
		club = new_club(name) unless club
		club.id
	end
	def new_club(name)
		club = Club.create(name: name)
		all_clubs
		club			
	end
	def all_clubs
		@clbs = Club.all
	end
	def extract_history(player, player_id, round = 0)
		gamehistory = []
		playergames = player["fixture_history"]["all"].select {|g| g if g[1] >= round }
		playergames.each do |sched|
			playerhistory = {:player_id => player_id}
			playerhistory[:gamedate] = DateTime.strptime(sched[0], '%d %b %H:%M')
			playerhistory[:round] = sched[1]
			game = sched[2].match(/(\w+)\((\w)\)\s(\d+)-(\d+)/)
			break unless game
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
		gamebreakup = gamehistory
		if @current_round > 0
			game = gamebreakup.select{|gm| gm[:round] == @current_round}[0]
			gamebreakup.delete(game)
			create_player_history(game, round, player_id)
		end
		create_player_history(gamebreakup, 0, player_id)
		gamehistory
	end
	def create_player_history(plyhist, round, player_id)
		if current_round(round)
			playerhistory = PlayerHistory.find_by(:player_id => player_id, :round => round)
			playerhistory.update_attributes(plyhist)
		else
			PlayerHistory.create(plyhist)
		end
	end
	def current_round(round)
		if @current_round == round and @current_round != 0
			true
		else
			false
		end
	end
	def get_current_round(player_id)
		if @current_round == 0
			@current_round = PlayerHistory.where(:player_id => player_id).maximum(:round)
		end
	end
	def player_attr
		{:web_name => :name, :first_name => :firstname, 
		 :second_name => :surname, :selected => :selected, 
		 :transfers_out => :transfers_out, :transfers_in => :transfers_in,
		 :total_points => :total_points, :original_cost => :cost_start,
		 :now_cost => :cost_now
		}
	end
end
