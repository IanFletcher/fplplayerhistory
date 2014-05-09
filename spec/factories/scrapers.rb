# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scraper do
    base_path "MyString"
    times_run 1
    duration_minutes 1
  end
end
