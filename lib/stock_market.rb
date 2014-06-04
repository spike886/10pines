class StockMarket
  
  attr_accessor :shares
  
  def for day
    @shares.each do |share|
      share.day=day
    end
  end
  
  def reset 
    @shares.each do |share|
      share.reset
    end
  end
end