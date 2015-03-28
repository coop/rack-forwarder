# Rack::Forwarder

[![Build Status](https://travis-ci.org/coop/rack-forwarder.svg?branch=master)](https://travis-ci.org/coop/rack-forwarder)

Declarative forwarding rack middleware based on
https://gist.github.com/chneukirchen/32376.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rack-forwarder"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-forwarder

## Usage

``` ruby
require "rack/forwarder"

use Rack::Forwarder do
  # Forward /foo/bar to http://localhost:5000/bar
  forward %r{/foo(/bar)}, to: "http://localhost:5000$1"

  # Forward /foo to http://localhost:5000/foo
  forward %r{/foo}, to: "http://localhost:5000"
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-forwarder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
