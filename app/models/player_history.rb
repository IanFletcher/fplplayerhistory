class PlayerHistory < ActiveRecord::Base
	has_one :player
	scope :by_venue, ->(location) do
		where("venue = (?)", location)
	end
end
