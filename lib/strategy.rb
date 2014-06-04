class Strategy
  
  attr_accessor :system
  
  def execute shares
    shares_to_sell=shares.select do |share|
      share.purchased && filter_shares_to_sell(share)
    end
    
    shares_to_buy=shares.select do |share|
      filter_shares_to_buy(share)
    end
    
    shares_to_buy.sort! do |first_share, second_share|
      sort_shares_to_buy first_share, second_share
    end
    
    @system.sell(shares_to_sell)
    @system.buy(shares_to_buy)
  end
  
end