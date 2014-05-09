# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player_history do
    round 1
    gamedate "2014-04-16 20:14:27"
    opponent "MyString"
    venue ""
    miniutes_played 1
    goals_scored 1
    assists 1
    clean_sheets 1
     ""
    own_goals 1
    penalty_saves 1
    penality_missed 1
    yellow_cards 1
    red_cards 1
    saves 1
    bonus 1
    esp 1
    bps 1
    net_transfers 1
    value "9.99"
    points 1
  end
end
