module Rack
  class Forwarder
    class Registry
      def initialize
        @store = []
      end

      def register(regexp, to)
        @store << Matcher.new(regexp, to)
      end

      def match?(path)
        @store.find { |matcher| matcher.match?(path) }
      end
    end
  end
end
