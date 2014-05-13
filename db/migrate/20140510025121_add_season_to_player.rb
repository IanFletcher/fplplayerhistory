class AddSeasonToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :season, :string, :limit => 4
  end
end
