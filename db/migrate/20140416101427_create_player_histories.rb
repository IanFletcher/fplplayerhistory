class CreatePlayerHistories < ActiveRecord::Migration
  def change
    create_table :player_histories do |t|
      t.integer :player_id
      t.integer :round                            ,:limit => 1
      t.datetime :gamedate
      t.string :opponent                          ,:limit => 30
      t.string :venue                            ,:limit => 1
      t.integer :miniutes_played                  ,:limit => 1
      t.integer :goals_scored                     ,:limit => 1
      t.integer :assists                          ,:limit => 1
      t.integer :clean_sheets                     ,:limit => 1
      t.integer :goals_conceded                     ,:limit => 1
      t.integer :own_goals                        ,:limit => 1
      t.integer :penalty_saves                    ,:limit => 1
      t.integer :penalty_missed                  ,:limit => 1
      t.integer :yellow_cards                     ,:limit => 1
      t.integer :red_cards                        ,:limit => 1
      t.integer :saves                            ,:limit => 1
      t.integer :bonus                            ,:limit => 1
      t.integer :esp                              ,:limit => 1
      t.integer :bps                              ,:limit => 1
      t.integer :net_transfers                    ,:limit => 4
      t.decimal :value                            ,precision:3
      t.integer :points                           ,:limit => 1

      t.timestamps
    end
  end
end
