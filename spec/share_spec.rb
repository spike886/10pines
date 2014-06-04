#share_spec.rb
require 'spec_helper'

describe Share do
  
  let(:date) { Date.new(2000,1,1)}
  let(:purchase_date){ Date.new(2000,11,11)}
  let(:share){ build :share, day: date }
  subject{ share }
  
  it{should respond_to :company}
  
  describe '#quote_history' do
    it{ should respond_to :quotes_history}
    it{ expect(share.quotes_history).to be_a History}
    it{ expect(share.quotes_history.entries).to_not be_empty}
    it{ expect(share.quotes_history.entries.first).to be_a Quote}
    it{ share.quotes_history.entries.each{|quote| quote.should be_a Quote} }
  end
  
  describe '#reset' do
    before do
      share.instance_eval{@quantity_purchased=2}
    end
    it{ should respond_to :reset}
    it{ expect(share.instance_eval{@quantity_purchased}).to eq 2}
    it "resets the value" do
      share.reset
      expect(share.instance_eval{@quantity_purchased}).to eq 0
    end
  end
  
  describe '#reset_purchase_date' do
    before do
      share.purchase_date=purchase_date
    end
    it{ expect(share.purchase_date).to_not eq nil}
    it "resets the date" do
      share.send(:reset_purchase_date)
      expect(share.purchase_date).to eq nil
    end
  end
  
  describe '#update_purchase_date' do
    context 'with a quantity purchased' do
      before do
        share.instance_eval{@quantity_purchased=2}
      end
      
      context 'with a previous date' do
        before do
          share.purchase_date=purchase_date
        end
        it{ expect(share.purchase_date).to eq purchase_date}
        it "updates the date" do
          share.send(:update_purchase_date)
          expect(share.purchase_date).to eq purchase_date
        end
      end
      
      context 'without a previous date' do
        it{ expect(share.purchase_date).to eq nil}
        it "updates the date" do
          share.send(:update_purchase_date)
          expect(share.purchase_date).to eq date
        end
      end
    end
    
    context 'without a quantity purchased' do
      context 'without a previous date' do
        it{ expect(share.purchase_date).to eq nil}
        it "does not update the date" do
          share.send(:update_purchase_date)
          expect(share.purchase_date).to eq nil
        end
      end
    end
    
    
  end
  
  describe '#purchased' do
    it{ should respond_to :purchased}
    it{ expect(share.purchased).to eq false}
    it "resets the value" do
      share.instance_eval{@quantity_purchased=2}
      expect(share.purchased).to eq true
    end
  end
  
  context 'with the day' do
    let(:price){ 5}
    let(:quote){ build :quote, price: price}
    let(:date){ quote.date}
    before do
      share.day=date
    end
    before do
      allow(share.quotes_history).to receive(:for).and_return(quote)
    end
      
    context '#price' do
      it{ should respond_to :price}
      it{ expect(share.price).to eq quote.price}
      it "calls history.for with the setted day" do
        expect(share.quotes_history).to receive(:for).with(date)
        share.price
      end
    end
    
    describe '#performace' do
      it{ should respond_to :performance}
      it{ expect(share.performance).to eq 1}
      it "calls history.for with the setted day" do
        expect(share.quotes_history).to receive(:for).with(date)
        expect(share.quotes_history).to receive(:for).with(date-1)
        share.performance
      end
    end
    
    describe '#buy' do
      it{ should respond_to :buy}
      
      it{ expect(share.buy(10)).to eq 10}
      it{ expect(share.buy(14)).to eq 10}
      it{ expect(share.buy(15)).to eq 15}
      
      it "adds the purchase to the quantity" do
        share.buy(10)
        expect(share.instance_eval{@quantity_purchased}).to eq 2
      end
      it "adds the purchase to the quantity even if no exact fare" do
        share.buy(14)
        expect(share.instance_eval{@quantity_purchased}).to eq 2
      end
      it "adds the purchase to the quantity" do
        share.buy(15)
        expect(share.instance_eval{@quantity_purchased}).to eq 3
      end
      it "creates a instance of BuyTransaction" do
        expect(BuyTransaction).to receive(:new).with(share, date, price, 2)
        share.buy(10)
      end
      it "calls update_purchase_date" do
        expect(share).to receive(:update_purchase_date).once
        share.buy(10)
      end
    end
    
    describe '#sell' do
      it{ should respond_to :sell}
      
      it "returns the money from the sell" do
        share.instance_eval{@quantity_purchased=2}
        expect(share.sell).to eq 10
      end
      
      it "returns the money from the sell" do
        share.instance_eval{@quantity_purchased=5}
        expect(share.sell).to eq 25
      end
      it "set the purchased quantity to zero" do
        share.instance_eval{@quantity_purchased=5}
        share.sell
        expect(share.instance_eval{@quantity_purchased}).to eq 0
      end
      it "creates a instance of SellTransaction" do
        expect(SellTransaction).to receive(:new).with(share, date, price, 5)
        share.instance_eval{@quantity_purchased=5}
        share.sell
      end
      it "calls reset_purchase_date" do
        expect(share).to receive(:reset_purchase_date).once
        share.sell
      end
    end
    
  end
end
