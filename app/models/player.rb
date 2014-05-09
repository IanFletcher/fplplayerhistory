class Player < ActiveRecord::Base
	has_one :club
	has_many :player_histories
end
