require 'spec_helper'
require 'ScrapePlayerHistory'

describe ScrapePlayerHistory do
	context '#extract_history' do
		before(:each) do
			@fplplayer_id = 214
			@ply = ScrapePlayerHistory.allocate
			@ply.stub(:webcontent).with(@fplplayer_id)
			  .and_return({"fixture_history"=>{"all"=>
				[["17 Aug 12:45", 1, "STK(H) 1-0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 110, 0], 
				["24 Aug 17:30", 2, "AVL(A) 1-0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -4282, 110, 0]
				]}})
			@suarez = @ply.webcontent(@fplplayer_id)
		end			
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
	end
end