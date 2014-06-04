FactoryGirl.define do
  factory :history do
    
    after(:build) do |history, evaluator|
      history.entries = (0...30).map do |n|
        FactoryGirl.build :quote, date: (Date.new(2000,1,1)+n)
      end
      history.sort
    end
  end
end