class AddSeasonToScraper < ActiveRecord::Migration
  def change
    add_column :scrapers, :season, :string, :limit => 4
  end
end
