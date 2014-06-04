#transaction_listener_spec.rb
require 'spec_helper'

describe TransactionListener do
  
  let(:listener){ build :transaction_listener }
  subject{ listener }
  
  describe '#transactions' do
    it{should respond_to :transactions}
    its(:transactions){ should be_a Array } 
    it{ expect(listener.transactions.first.class).to be <= Transaction}
  end
  
  describe '#created_transaction' do
    let(:instance){ double("instance")}
    it{should respond_to :created_transaction}
    it "stores the intance of the new transacion" do
      listener.created_transaction(instance)
      expect(listener.transactions).to end_with instance
    end
  end
  
end
