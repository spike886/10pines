#second_strategy_spec.rb
require 'spec_helper'

describe FirstStrategy do
  
  let(:share){ double('share')}
  let(:second_share){ double('second share')}
  let(:strategy){ SecondStrategy.new }
  let(:system){ double("system") }
  let(:date){ Date.new(2000,1,1)}
  subject{ strategy }
  before do
    allow(system).to receive(:today).and_return(date)
    allow(share).to receive(:averange_price).and_return(1)
    allow(second_share).to receive(:averange_price).and_return(1)
    strategy.system=system
  end
  
  it{ strategy.class.should be <= Strategy}
  
  describe '#filter_shares_to_sell' do
    it "does not sell the shares if its not the correct date" do
      allow(share).to receive(:purchase_date).and_return(date-3)
      expect(strategy.filter_shares_to_sell(share)).to eq false
    end
    it "sells if its the shares not the correct date" do
      allow(share).to receive(:purchase_date).and_return(date-5)
      expect(strategy.filter_shares_to_sell(share)).to eq true
    end
  end
  
  describe '#filter_shares_to_buy' do
    
    context 'with bad proformance' do
      before do
        allow(share).to receive(:performance).and_return(1)
      end
      
      context 'with bad price' do
        before do
          allow(share).to receive(:price).and_return(1.5)
        end
        
        it "does not buy the shares" do
          expect(strategy.filter_shares_to_buy(share)).to eq false
        end
      end
      
      context 'with good price' do
        before do
          allow(share).to receive(:price).and_return(2.5)
        end
        
        it "buys the shares" do
          expect(strategy.filter_shares_to_buy(share)).to eq true
        end
      end
    end
    
    context 'with good proformance' do
      before do
        allow(share).to receive(:performance).and_return(0.8)
      end
      
      context 'with bad price' do
        before do
          allow(share).to receive(:price).and_return(1.5)
        end
        
        it "buys the shares" do
          expect(strategy.filter_shares_to_buy(share)).to eq true
        end
      end
      
      context 'with good price' do
        before do
          allow(share).to receive(:price).and_return(2.5)
        end
        
        it "buys the shares" do
          expect(strategy.filter_shares_to_buy(share)).to eq true
        end
      end
    end
  end
  
  describe '#sort_shares_to_buy' do
    
    it{should respond_to :sort_shares_to_buy}
    context 'with the same performance' do
      before do
        allow(share).to receive(:performance).and_return(0.7)
        allow(second_share).to receive(:performance).and_return(0.7)
      end
      
      it "sorts the best price at the first position" do
        allow(share).to receive(:price).and_return(4)
        allow(second_share).to receive(:price).and_return(2)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(-1)
      end
      
      it "sorts the worst price at the last position" do
        allow(share).to receive(:price).and_return(2)
        allow(second_share).to receive(:price).and_return(4)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(1)
      end
      
      it "does not move if they have the same price" do
        allow(share).to receive(:price).and_return(2)
        allow(second_share).to receive(:price).and_return(2)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(0)
      end
    end
    
    context 'with the same price' do
      before do
        allow(share).to receive(:price).and_return(2)
        allow(second_share).to receive(:price).and_return(2)
      end
      
      it "sorts the best performance at the first position" do
        allow(share).to receive(:performance).and_return(0.5)
        allow(second_share).to receive(:performance).and_return(0.7)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(-1)
      end
      
      it "sorts the worst performance at the last position" do
        allow(share).to receive(:performance).and_return(0.8)
        allow(second_share).to receive(:performance).and_return(0.7)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(1)
      end
      
      it "does not move if they have the same performance" do
        allow(share).to receive(:performance).and_return(0.7)
        allow(second_share).to receive(:performance).and_return(0.7)
        expect(strategy.sort_shares_to_buy(share,second_share)).to eq(0)
      end
    end
  end
    
end
