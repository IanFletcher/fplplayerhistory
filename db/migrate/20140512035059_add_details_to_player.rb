class AddDetailsToPlayer < ActiveRecord::Migration
  def change
  	add_column :players, :position, :string, :limit => 1
  	add_column :players, :selected, :integer
  	add_column :players, :transfers_out, :integer
  	add_column :players, :transfers_in, :integer
  	add_column :players, :total_points, :integer, :limit => 2
  	add_column :players, :cost_start, :integer, :limit => 2
  	add_column :players, :cost_now, :integer, :limit => 2
  end
end
