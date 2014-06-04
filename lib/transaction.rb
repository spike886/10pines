class Transaction
  attr_accessor :share
  attr_accessor :date
  attr_accessor :price
  attr_accessor :quantity
  
  @@listeners=[]
    
  def initialize share, date, price, quantity
    @share=share
    @date=date
    @price=price
    @quantity=quantity
    
    Transaction.inform_creation self
  end
  
  def self.register_listener listener
    @@listeners<<listener
  end
  
  def self.unregister_listener listener
    @@listeners.delete listener
  end
  
  def self.inform_creation instance
    @@listeners.each do |listener|
      listener.created_transaction instance
    end
  end
end