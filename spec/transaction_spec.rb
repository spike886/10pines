#transaction_spec.rb
require 'spec_helper'

[BuyTransaction, SellTransaction].each do |klass|
  
  describe klass do
    let(:object){ build klass.name.underscore.to_sym}
    let(:share){ object.share}
    subject{ object }
    
    describe '#date' do
      it{should respond_to :date}
      its(:date){ should be_a Date}
    end
    
    describe '#price' do
      it{should respond_to :price}
      its(:price){ should be_a Numeric }
    end
    
    describe '#quantity' do
      it{should respond_to :quantity}
      its(:quantity){ should be_a Numeric }
    end
    
    describe '#share' do
      it{should respond_to :share}
      its(:share){ should be_a Share }
    end
    
    it "informs the creation of the transaction" do 
      expect(Transaction).to receive(:inform_creation).with(kind_of(klass))
      object
    end
    
    describe "listeners" do
      let(:listener){ double("listener")}
      let(:instance){ double("instance")}
      it "adds the instance to the transactions list" do 
        expect(listener).to receive(:created_transaction).with(instance)
        Transaction.register_listener listener
        klass.inform_creation instance
        Transaction.unregister_listener listener
      end
    end
  end
end
