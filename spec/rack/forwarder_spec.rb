require "spec_helper"
require "rack/test"

RSpec.describe Rack::Forwarder do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.new do
      use Rack::Forwarder do
        forward %r{/foo(/bar)}, to: "http://example.com$1"
        forward %r{/foo}, to: "http://example.com"
      end

      run ->(env) { [200, {"Content-Type" => "text/plain"}, ["hello world"]] }
    end
  end

  context "none matching" do
    it "is successful" do
      get "/"

      expect(last_response).to be_successful
      expect(last_response.body).to eq("hello world")
    end
  end

  context "forwarding" do
    it "forwards the specified regex" do
      Excon.stub({url: "http://example.com/foo"}, status: 200)

      get "/foo"
    end
  end

  context "capture groups" do
    it "transforms the path based on capture groups" do
      Excon.stub({url: "http://example.com/bar"}, status: 200)

      get "/foo/bar"
    end
  end
end
