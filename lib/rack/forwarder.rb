require "excon"
require "rack"

require "rack/forwarder/version"
require "rack/forwarder/matcher"
require "rack/forwarder/registry"

module Rack
  class Forwarder
    HEADERS_TO_FORWARD = %w(
      Content-Type
      Content-Length
    )

    def initialize(app, options = {}, &block)
      @app = app
      @matchers = Registry.new
      @options = options
      instance_eval(&block)
    end

    def forward(regexp, to:)
      @matchers.register(regexp, to)
    end

    def call(env)
      request = Request.new(env)
      matcher = @matchers.match?(request.path)
      return @app.call(env) unless matcher

      request_method = request.request_method.to_s.downcase
      options = {
        headers: extract_http_headers(env),
      }.merge(@options)
      response = Excon.public_send(
        request_method,
        matcher.url_from(request.path),
        options,
      )

      [response.status, headers_from_response(response.headers), [response.body]]
    end

    private

    def extract_http_headers(env)
      headers = env.each_with_object(Utils::HeaderHash.new) do |(key, value), hash|
        hash[$1] = value if key =~ /HTTP_(.*)/
      end
      headers["X-Request-Id"] = env["action_dispatch.request_id"]

      headers
    end

    def headers_from_response(headers)
      HEADERS_TO_FORWARD.each_with_object(Utils::HeaderHash.new) do |header, hash|
        value = headers[header]
        hash[header] = value if value
      end
    end
  end
end
