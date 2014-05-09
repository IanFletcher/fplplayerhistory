class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name											,limit:30
      t.string :firstname									,limit:30
      t.string :surname										,limit:30
      t.integer :club_id
      t.integer :fplplayer_id							,limit:2
      t.timestamps
    end
  end
end
