module Rack
  class Forwarder
    class Registry
      Matcher = Struct.new(:regexp, :to) do
        def match?(path)
          regexp =~ path
        end

        def url_from(path)
          return URI.join(to, path).to_s unless to =~ /\$\d+/

          regexp.match(path).captures.to_enum
            .with_index(1).each_with_object(to) do |(match, index), url|
              url.gsub!("$#{index}", match)
            end
        end
      end
    end
  end
end
