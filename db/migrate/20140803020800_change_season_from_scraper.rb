class ChangeSeasonFromScraper < ActiveRecord::Migration
  def up
    change_column :scrapers, :season, :string, :limit => 9
  end
  def down
    change_column :scrapers, :season, :string, :limit => 4
  end

end
