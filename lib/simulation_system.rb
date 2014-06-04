require "transaction_listener"

class SimulationSystem
  
  attr_accessor :total_amount
  attr_accessor :transaction_listener
  
  def initialize from, to, stock_market, strategy, value_of_purchase, total_amount
    @from=from
    @to=to
    @stock_market=stock_market
    @stock_market.reset
    @strategy=strategy
    @strategy.system=self
    @value_of_purchase=value_of_purchase
    @total_amount=total_amount
    @transaction_listener= TransactionListener.new
  end
  
  def simulate
    @transaction_listener.register
    (@from .. @to).each do |today|
      @current_day=today
      
      @strategy.execute(@stock_market.for(today))
    end
    
    sell_all
    @transaction_listener.unregister
  end
  
  def today
    @current_day
  end
  
  def sell shares
    shares.each do |share|
      earned_amount=share.sell
      @total_amount+=earned_amount
    end
  end
  
  def sell_all
    sell @stock_market.for(@to)
  end
  
  def buy shares
    shares.each do |share|
      amount_to_spend= @value_of_purchase<@total_amount ? @value_of_purchase : @total_amount
      spended_amount=share.buy amount_to_spend
      @total_amount-=spended_amount
    end
  end
end