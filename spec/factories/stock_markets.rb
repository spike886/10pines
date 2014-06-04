FactoryGirl.define do
  factory :stock_market do
    shares { FactoryGirl.build_list :share, 3 }
    
  end
end