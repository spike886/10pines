#simulation_system_spec.rb
require 'spec_helper'

describe SimulationSystem do
  
  let(:shares_count){ stock_market.shares.count }
  let(:value_of_purchase){ simulation_system.instance_eval{@value_of_purchase} }
  let(:total_amount){ simulation_system.instance_eval{@total_amount} }
  let(:stock_market){ simulation_system.instance_eval{@stock_market} }
  let(:from_date){ simulation_system.instance_eval{@from} }
  let(:to_date){ simulation_system.instance_eval{@to} }
  let(:amount_of_dates){ (from_date .. to_date).count }
  let(:shares){ stock_market.for(from_date)}
  let(:transaction_listener){ simulation_system.transaction_listener}
  let(:strategy){ simulation_system.instance_eval{@strategy} }
  let(:simulation_system){ build :simulation_system }
  subject{ simulation_system }
    
  describe '#simulate' do
    it{should respond_to :simulate} 
    it "calls strategy execute method once per day" do
      expect(strategy).to receive(:execute).exactly(amount_of_dates).times
      simulation_system.simulate
    end
    it "calls strategy execute method with shares" do
      expect(strategy).to receive(:execute).exactly(amount_of_dates).times do |shares|
        shares.each{ |share| expect(share).to be_a Share}
      end
      simulation_system.simulate
    end
    it "calls strategy execute method with shares with the correct day setted" do
      (from_date .. to_date).each do |date|
        expect(strategy).to receive(:execute) do |shares|
          expect(shares.first.day).to eq date
        end.ordered
      end
      simulation_system.simulate
    end
    it "sets current_day correctly each time in the simulation" do
      (from_date .. to_date).each do |date|
        expect(strategy).to receive(:execute) do |shares|
          expect(simulation_system.today).to eq date
        end.ordered
      end
      simulation_system.simulate
    end
    it "calls sell_all methood after all strategys were executed" do
      expect(strategy).to receive(:execute).exactly(amount_of_dates).times.ordered
      expect(simulation_system).to receive(:sell_all).once.ordered
      simulation_system.simulate
    end
    it "listens the the transaction" do
      expect(transaction_listener).to receive(:register).once.ordered
      expect(strategy).to receive(:execute).exactly(amount_of_dates).times.ordered
      simulation_system.simulate
    end
    it "stops listening after the execution" do
      expect(simulation_system).to receive(:sell_all).once.ordered
      expect(transaction_listener).to receive(:unregister).once.ordered
      simulation_system.simulate
    end
  end
    
  describe '#total_amount' do
    it{should respond_to :total_amount} 
    its(:total_amount){should be_a Numeric}
  end
    
  describe '#transaction_listener' do
    it{should respond_to :transaction_listener} 
    its(:transaction_listener){should be_a TransactionListener}
  end
  
  describe '#buy' do
    it{should respond_to :buy}
    it "buys shares" do
      simulation_system.buy(shares)
      shares.each{ |share| expect(share.purchased).to eq true}
    end
    it "buys the correct quantity of shares" do
      simulation_system.buy(shares)
      shares.each{ |share| expect(share.instance_eval{@quantity_purchased}).to eq 10}
    end
    it "substracts the money for one purchase" do
      expect{simulation_system.buy([shares.first])}.to change{ simulation_system.instance_eval{@total_amount} }.by(-value_of_purchase)
    end
    it "substract the money for all the purchases" do
      expect{simulation_system.buy(shares)}.to change{simulation_system.instance_eval{@total_amount} }.by(-value_of_purchase*shares_count)
    end
    it "substract the remaining money if not enough for all" do
      simulation_system.instance_eval{@total_amount=2000}
      simulation_system.buy(shares)
      expect(simulation_system.instance_eval{@total_amount}).to eq 0
    end
    it "does not purchase all the shares if not enough money" do
      simulation_system.instance_eval{@total_amount=2000}
      simulation_system.buy(shares)
      expect(shares.last.instance_eval{@quantity_purchased}).to eq 0
    end
  end
  
  describe '#sell' do
    before do
      shares.each{|share| share.instance_eval{@quantity_purchased=10}}  
    end
    
    it{should respond_to :sell}
    it "has shares" do
      shares.each{ |share| expect(share.purchased).to eq true}
    end
    it "sells the shares" do
      simulation_system.sell shares
      shares.each{ |share| expect(share.purchased).to eq false}
    end
    it "sets purchased quantity to zero" do
      simulation_system.sell shares
      shares.each{ |share| expect(share.instance_eval{@quantity_purchased}).to eq 0}
    end
    it "adds the money for one purchase" do
      expect{simulation_system.sell([shares.first])}.to change{ simulation_system.instance_eval{@total_amount} }.by(value_of_purchase)
    end
    it "adds the money for all the purchases" do
      expect{simulation_system.sell(shares)}.to change{simulation_system.instance_eval{@total_amount} }.by(value_of_purchase*shares_count)
    end
  end
end
