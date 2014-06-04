FactoryGirl.define do
  factory :simulation_system do
    from { Date.new(2000,1,2)}
    to { Date.new(2000,1,3)}
    stock_market { FactoryGirl.build :stock_market}
    strategy {FirstStrategy.new}
    value_of_purchase {1000}
    total_amount {1000000}
    
    initialize_with { new from, to, stock_market, strategy, value_of_purchase, total_amount }
    
    factory :simulation_system_first_strategy do
      strategy {FirstStrategy.new}
    end
    
    factory :simulation_system_second_strategy do
      strategy {SecondStrategy.new}
    end
  end
end