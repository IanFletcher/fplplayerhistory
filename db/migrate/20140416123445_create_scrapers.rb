class CreateScrapers < ActiveRecord::Migration
  def change
    create_table :scrapers do |t|
      t.string :base_path
      t.integer :times_run
      t.integer :duration_minutes
      t.integer :number_of_players

      t.timestamps
    end
  end
end
