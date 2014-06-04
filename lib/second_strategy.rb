require "strategy"

class SecondStrategy < Strategy
  
  def filter_shares_to_sell share
    @system.today-5 == share.purchase_date
  end
  
  def filter_shares_to_buy share
    ( share.performance <= 0.99 ) || ( share.price/share.averange_price >2) 
  end
  
  def sort_shares_to_buy fisrt_share, second_share
    (1/second_share.performance)+(second_share.price/second_share.averange_price/2) <=> (1/fisrt_share.performance)+(fisrt_share.price/fisrt_share.averange_price/2)
  end
end