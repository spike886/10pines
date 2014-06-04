require "transaction"

class TransactionListener
  attr_accessor :transactions
  
  def initialize
    @transactions=[]
  end
  
  def register
    Transaction.register_listener self
  end
  
  def unregister
    Transaction.unregister_listener self
  end
  
  def created_transaction transaction
    @transactions<< transaction
  end
end