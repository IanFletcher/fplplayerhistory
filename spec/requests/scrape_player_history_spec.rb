require 'spec_helper'
require 'ScrapePlayerHistory'

describe ScrapePlayerHistory do
	before(:each) do
		@fplplayer_id = 214
		@ply = ScrapePlayerHistory.allocate
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
end