FactoryGirl.define do
  factory :share do
    sequence(:company) {|n| "company_n#{n}"} 
    
    after(:build) do |share|
      share.quotes_history=FactoryGirl.build :history
    end
    
  end
end