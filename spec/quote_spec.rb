#quote_spec.rb
require 'spec_helper'

describe Quote do
  
  let(:share){ build :share }
  let(:quote){ share.quotes_history.entries.first }
  subject{ quote }
  
  describe '#date' do
    it{should respond_to :date}
    its(:date){ should be_a Date}
  end
  
  describe '#price' do
    it{should respond_to :price}
    its(:price){ should be_a Numeric }
  end
end
