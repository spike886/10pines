require 'rubygems'
require 'factory_girl'
require 'rspec/its'
require 'ruby-debug'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

$LOAD_PATH.unshift << File.join(File.dirname(__FILE__), '..', 'lib')

Dir[File.join(File.dirname(__FILE__), '..', 'lib','*.rb')].each {|file| require file }

Dir[File.join(File.dirname(__FILE__), 'factories','*.rb')].each {|file| require file}