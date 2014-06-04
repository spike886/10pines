class Share
  attr_accessor :company
  attr_accessor :quotes_history
  attr_accessor :day
  attr_accessor :purchase_date
  
  def initialize
    @quantity_purchased=0
  end
  
  def price
    @quotes_history.for(@day).price
  end
  
  def performance
    @quotes_history.for(@day).price/@quotes_history.for(@day-1).price
  end
  
  def purchased
    @quantity_purchased!=0
  end
  
  def averange_price
    @quotes_history.to(@day).averange_price
  end
  
  def reset
    @quantity_purchased=0
  end
  
  def buy money
    quantity_to_purchase=money/price
    quantity_to_purchase=quantity_to_purchase.to_i
    @quantity_purchased+=quantity_to_purchase
    update_purchase_date
    BuyTransaction.new(self, @day, price, quantity_to_purchase)
    quantity_to_purchase*price
  end
  
  def sell
    money=@quantity_purchased*price
    SellTransaction.new(self, @day, price, @quantity_purchased) if @quantity_purchased >0
    @quantity_purchased=0
    reset_purchase_date
    money
  end
  
private
  
  def update_purchase_date
    @purchase_date||= @day if @quantity_purchased>0
  end
  
  def reset_purchase_date
    @purchase_date= nil
  end
  
end