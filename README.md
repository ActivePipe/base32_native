# Base32Native

A native Base32 gem to speed up your encoding and decoding.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'base32_native'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install base32_native

## Usage

```
encoded = Base32Native.encode(string)
decoded = Base32Native.decode(string)
```

## Development

```
gem install rake-compiler
cd base32_native
rake compile
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ActivePipe/base32_native. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

