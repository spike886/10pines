#stock_market_spec.rb
require 'spec_helper'

describe StockMarket do
  
  let(:stock_market){ build :stock_market }
  let(:shares_count){ stock_market.shares.count}
  subject{ stock_market }
  
  describe '#shares' do
    it {should respond_to :shares}
    its(:shares){ should be_a Array}
    its(:shares){ should_not be_empty}
    it{ expect(stock_market.shares.first).to be_a Share}
    it{ stock_market.shares.each{|share| share.should be_a Share} }
  end
  
  describe '#for' do
    let(:date){ Date.new(2000,1,1) }
    
    it{ should respond_to :for}
    it{ expect(stock_market.for(date)).to be_a Array}
    it{ expect(stock_market.for(date)).to_not be_empty}
    it{ expect(stock_market.for(date).first).to be_a Share}
    it{ stock_market.for(date).each{|share| expect(share).to be_a Share} }
    it "sets the day to every share" do
      expect_any_instance_of(Share).to receive(:day=).with(date).any_number_of_times
    end
  end
  
  describe '#reset' do
    it{ should respond_to :reset}
    
    it "calls reset for every share" do
      allow_any_instance_of(Share).to receive(:reset)
      stock_market.reset
    end
  end
end
