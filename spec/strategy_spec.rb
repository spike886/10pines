#strategy_spec.rb
require 'spec_helper'

describe Strategy do
  
  let(:strategy){ Strategy.new }
  subject{ strategy }
  
  describe '#execute' do
    let(:shares_count){5}
    let(:share){double("share")}
    let(:shares){ (0...shares_count).map{share}}
    let(:system){ double("system")}
    before do
      allow(share).to receive(:purchased).and_return(true)
      allow(strategy).to receive(:filter_shares_to_sell).and_return(true)
      allow(strategy).to receive(:filter_shares_to_buy).and_return(true)
      allow(strategy).to receive(:sort_shares_to_buy).and_return(1)
      allow(system).to receive(:sell)
      allow(system).to receive(:buy)
      strategy.system=system
    end
    
    it{should respond_to :execute}
    it "calls the sell filter method" do
      expect(strategy).to receive(:filter_shares_to_sell).exactly(shares_count).times
      strategy.execute(shares)
    end
    it "calls the buy filter method" do
      expect(strategy).to receive(:filter_shares_to_buy).exactly(shares_count).times
      strategy.execute(shares)
    end
    it "calls the buy sort method" do
      expect(strategy).to receive(:sort_shares_to_buy)
      strategy.execute(shares)
    end
    it "calls the buy method with all the shares" do
      expect(system).to receive(:buy).with(shares)
      strategy.execute(shares)
    end
    it "calls the sell method with all the shares" do
      expect(system).to receive(:sell).with(shares)
      strategy.execute(shares)
    end
    it "calls the buy method with no shares" do
      allow(strategy).to receive(:filter_shares_to_sell).and_return(false)
      expect(system).to receive(:sell).with([])
      strategy.execute(shares)
    end
    it "calls the sell method with no shares" do
      allow(strategy).to receive(:filter_shares_to_buy).and_return(false)
      expect(system).to receive(:buy).with([])
      strategy.execute(shares)
    end
    
  end
end
