FactoryGirl.define do
  factory :transaction do
    share { FactoryGirl.build :share}
    date { Date.new(2000,1,1)}
    price { 2 }
    quantity { 5 }
    
    initialize_with { new share, date, price, quantity }
    factory :buy_transaction, class: BuyTransaction do
    end
    
    factory :sell_transaction, class: SellTransaction do
    end
  end
end