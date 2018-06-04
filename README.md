# CreditCardFinder

This gem allows you to find some credit card information by BIN/IIN code. Now it uses two strategies for search. First strategy use 'credit_card_bins' gem and provide search in YAML files.
Second strategy use bincodes.com API (so you will need register and get api key).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'credit_card_finder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install credit_card_finder

## Configuration

```ruby
CreditCardFinder::Config.configure do |config|
    config.bincodes.api_key = 'your_api_key'
    
    # set timeout for api request
    config.bincodes.timeout = 10 # already set by default
    
    # alredy set by default
    config.strategies = %w[CreditCardBinsStrategy BincodesStrategy]
    
    # also you can use custom logger instance
    config.logger = Logger.new(STDOUT)
end
```

## Usage

If you want use strategies for search, you just need make call:

```ruby
bin = '427664'
CreditCardFinder.lookup(bin)
```

By default that call will be search firstly in YAML files via `credit_card_bins` gem, and if find nothing, will search via bincodes.com.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serverscom/credit-card-finder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CreditCardFinder project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/serverscom/credit-card-finder/blob/master/CODE_OF_CONDUCT.md).
