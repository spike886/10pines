class History 
  attr_accessor :entries
  
  def initialize
    @entries=[]
  end
  
  def sort
    @entries.sort!{|first_quote,second_quote| first_quote.date <=> second_quote.date}
  end
  
  def averange_price
    averange=0
    @entries.each do |quote|
      averange+=quote.price
    end
    averange/@entries.count
  end
  
  def to date
    history=History.new
    history.entries=@entries.select{|quote| quote.date<=date}
    history
  end
  
  def for date
    @entries.select{|quote| quote.date==date}.first
  end
end

