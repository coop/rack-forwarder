$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rack/forwarder"

RSpec.configure do |config|
  config.before(:all) do
    Excon.defaults[:mock] = true
  end

  config.after(:each) do
    Excon.stubs.clear
  end
end
