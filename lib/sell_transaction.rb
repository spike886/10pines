require "transaction"

class SellTransaction < Transaction
  
  def initialize share, day, price, quantity
    super share, day, price, quantity
  end
end