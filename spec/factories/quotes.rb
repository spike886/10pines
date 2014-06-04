FactoryGirl.define do
  factory :quote do
    price 100
    date {Date.new(2000,1,1)}
  end
end