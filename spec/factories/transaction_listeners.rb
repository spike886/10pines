FactoryGirl.define do
  factory :transaction_listener do
    transactions { FactoryGirl.build_list :buy_transaction, 5}
  end
end