require 'spec_helper'
require 'ScrapePlayerHistory'

describe ScrapePlayerHistory do
	describe 'Full scrape ' do
		before(:each) do
			@fplplayer_id = 214
			@ply = ScrapePlayerHistory.new(true, Scraper.find(1))
			suarezcontent = File.read(Rails.root.join("spec/support/214.json")) 
			FakeWeb.clean_registry
			FakeWeb.register_uri(:get, "http://fantasy.premierleague.com/web/api/elements/214/", :body => suarezcontent)
			@suarez = @ply.webcontent(@fplplayer_id)
		end
		context '@extract_player' do
			it 'can create a new player hash' do
				@ply.stub(:create_player).and_return(22)
				expect(@ply.extract_player(@suarez, @fplplayer_id)).to eql 22
			end
			it 'calls the create_player method' do
				@ply.should_receive(:create_player)
				@ply.extract_player(@suarez, @fplplayer_id)
			end
			it 'creates a new player' do
				expect{@ply.extract_player(@suarez, @fplplayer_id)}.to change(Player, :count).by(1)
			end
		end
		context '#extract_history' do			
			it 'can extract game history of player' do
				@ply.stub(:create_player_history)
				suarezgamehistory = @ply.extract_history(@suarez, @fplplayer_id)
				expect(suarezgamehistory).to be_kind_of Array
				expect(suarezgamehistory[0]).to be_kind_of Hash
				expect(suarezgamehistory[0]).to include :player_id
			end
			it 'calls create_player_history' do
				@ply.should_receive(:create_player_history)
				@ply.extract_history(@suarez, @fplplayer_id)				
			end
			it 'creates a player history' do
				expect{@ply.extract_history(@suarez, @fplplayer_id)}.to change(PlayerHistory, :count).by(37)
			end	
		end
		context '#webcontent' do
			it 'should return false if no webpage' do
				FakeWeb.register_uri(:get, "http://fantasy.premierleague.com/web/api/elements/10000/", :status => 500)
				@ply.webcontent(10000)
			end
			it 'should return the player info in json' do
				expect(@ply.webcontent(@fplplayer_id)["id"]).to eq @fplplayer_id
			end
		end
		context '#refresh_database' do
			it 'should remove player records' do
				player = @ply.webcontent(@fplplayer_id)
				@ply.extract_player(player, @fplplayer_id)
				expect{@ply.refresh_database}.to change(Player, :count).by(-1)
			end
			it 'should remove player history records' do
				player = @ply.webcontent(@fplplayer_id)
				player_id = @ply.extract_player(player, @fplplayer_id)
				@ply.extract_history(player, player_id)
				expect{@ply.refresh_database}.to change(PlayerHistory, :count).by(-37)
			end
		end
		context '#club_check' do
			it 'should create a new if none found' do
				expect{@ply.club_check('Chelsea')}.to change(Club, :count).by(1)
			end
			it 'should return the club id' do
				club_id = @ply.club_check('Chelsea')
				expected_club_id = Club.find_by(name: 'Chelsea')[:id]
				expect(club_id).to eq(expected_club_id)
			end
		end
	end
	describe 'scrape update' do
		before(:each) do
			@fplplayer_id = 214
			@ply = ScrapePlayerHistory.new(false, Scraper.find(1))
			suarezcontent = File.read(Rails.root.join("spec/support/214.json")) 
			FakeWeb.clean_registry
			FakeWeb.register_uri(:get, "http://fantasy.premierleague.com/web/api/elements/214/", :body => suarezcontent)
			@suarez = @ply.webcontent(@fplplayer_id)
			@player_id = @ply.extract_player(@suarez, @fplplayer_id)
			@ply.extract_history(@suarez, @player_id)
			PlayerHistory.delete_all("round > 20")
		end
		context '#player_updater' do
			it 'should find player and up to date history' do
				expect{@ply.player_updater}.to change(PlayerHistory, :count).by(17)
			end
			it 'should update last round with new stats' do
				suarezhistory = PlayerHistory.find_by(:player_id => @player_id, :round => 20)
				suarezhistory.update_attributes(:own_goals => 9) 
				@ply.player_updater
				suarezhistory.reload
				expect(suarezhistory.own_goals).to eq 0
			end
		end
		context '#get_current_round' do
			it 'should get the maxium round in database' do
				expect(@ply.get_current_round(@player_id)).to eq 20
			end
		end
		context '#update_scraper' do
			it 'add to scraper run times' do
				@ply.update_scraper(DateTime.now)
				expect(Scraper.find(1).times_run).to eq 1
			end
		end
	end
end
