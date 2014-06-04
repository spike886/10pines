#history_spec.rb
require 'spec_helper'

describe History do
  
  let(:share){ build :share }
  let(:history){ share.quotes_history }
  let(:last_quote){ history.entries.last() }
  subject{ history }
  
  describe 'entries' do
    it "orders by date ascending" do
       last=nil
       history.entries.each do |entry|
         last.date.should be < entry.date if last
         last=entry 
       end
    end
  end
  
  describe '#entries' do
    it{should respond_to :entries}
    its(:entries){ should be_a Array}
    its("entries.first"){ should be_a Quote}
  end
  
  describe '#averange_price' do
    let(:return_value) {5}
    before do
      allow_any_instance_of(Quote).to receive(:price).and_return(return_value)
    end
    
    it{should respond_to :averange_price}
    its(:averange_price){should be return_value}
  end
  
  describe '#to' do
    let(:filter_date){Date.new(2000,1,3)}
    it{ should respond_to :to}
    it{ expect(history.to(filter_date)).to be_a History}
    it{ expect(history.to(filter_date).entries.last.date).to eq filter_date}
    it "has only history entreis after the given date" do
       history_new=history.to(filter_date)
       history_new.entries.each do |entry|
         filter_date.should be >= entry.date
       end
    end
  end
  
  describe '#for' do
    let(:filter_date){Date.new(2000,1,3)}
    it{ should respond_to :for}
    it{ expect(history.for(filter_date)).to be_a Quote}
    it{ expect(history.for(filter_date).date).to eq filter_date}
  end
  
end
