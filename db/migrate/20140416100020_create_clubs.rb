class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name											,limit:30
      t.string :shortname									,limit:3
      t.integer :predicted_finish					,limit:1

      t.timestamps
    end
  end
end
