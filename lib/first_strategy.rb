require "strategy"

class FirstStrategy < Strategy
  
  def filter_shares_to_sell share
    share.performance >= 1.02
  end
  
  def filter_shares_to_buy share
    share.performance <= 0.99
  end
  
  def sort_shares_to_buy fisrt_share, second_share
    fisrt_share.performance <=> second_share.performance
  end
end