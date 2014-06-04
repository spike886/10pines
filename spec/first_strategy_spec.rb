#first_strategy_spec.rb
require 'spec_helper'

describe FirstStrategy do
  
  let(:share){ double('share')}
  let(:second_share){ double('second share')}
  let(:strategy){ FirstStrategy.new }
  subject{ strategy }
  
  it{ strategy.class.should be <= Strategy}
  
  describe '#filter_shares_to_sell' do
    
    it{should respond_to :filter_shares_to_sell}
    it "sells the shares if performance is is 1.02" do
      expect(share).to receive(:performance).and_return(1.02)
      expect(strategy.filter_shares_to_sell(share)).to eq true
    end
    it "sells the shares if performance is is 1.5" do
      expect(share).to receive(:performance).and_return(1.5)
      expect(strategy.filter_shares_to_sell(share)).to eq true
    end
    it "does not sell the shares if performance is is 1.019" do
      expect(share).to receive(:performance).and_return(1.019)
      expect(strategy.filter_shares_to_sell(share)).to eq false
    end
    it "does not sell the shares if performance is is 0.9" do
      expect(share).to receive(:performance).and_return(0.9)
      expect(strategy.filter_shares_to_sell(share)).to eq false
    end
    
  end
  
  describe '#filter_shares_to_buy' do
    
    it{should respond_to :filter_shares_to_buy}
    it "buys the shares if performance is is 0.99" do
      expect(share).to receive(:performance).and_return(0.99)
      expect(strategy.filter_shares_to_buy(share)).to eq true
    end
    it "buys the shares if performance is is 0.8" do
      expect(share).to receive(:performance).and_return(0.8)
      expect(strategy.filter_shares_to_buy(share)).to eq true
    end
    it "does not buy the shares if performance is is 1" do
      expect(share).to receive(:performance).and_return(1)
      expect(strategy.filter_shares_to_buy(share)).to eq false
    end
    it "does not buy the shares if performance is is 1.9" do
      expect(share).to receive(:performance).and_return(1.9)
      expect(strategy.filter_shares_to_buy(share)).to eq false
    end
    
  end
  
  describe '#sort_shares_to_buy' do
    
    it{should respond_to :sort_shares_to_buy}
    it "sorts the worst performance at the first position" do
      expect(share).to receive(:performance).and_return(0.7)
      expect(second_share).to receive(:performance).and_return(0.9)
      expect(strategy.sort_shares_to_buy(share,second_share)).to eq -1
    end
    it "sorts the best performance at the last position" do
      expect(share).to receive(:performance).and_return(0.9)
      expect(second_share).to receive(:performance).and_return(0.7)
      expect(strategy.sort_shares_to_buy(share,second_share)).to eq 1
    end
    it "does not move if they have the same performance" do
      expect(share).to receive(:performance).and_return(0.7)
      expect(second_share).to receive(:performance).and_return(0.7)
      expect(strategy.sort_shares_to_buy(share,second_share)).to eq 0
    end
  end
    
end
