class AddClubScore < ActiveRecord::Migration
  def change
  	add_column :player_histories,	:club_score,	:integer, 	:limit => 1
  	add_column :player_histories,	:opposition_score,	:integer, 	:limit => 1  
  	
  	add_index :player_histories, :player_id
  end
end
