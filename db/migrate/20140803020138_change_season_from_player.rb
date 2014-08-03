class ChangeSeasonFromPlayer < ActiveRecord::Migration
  def up
    change_column :players, :season, :string, :limit => 9
  end
  def down
    change_column :players, :season, :string, :limit => 4
  end
end
