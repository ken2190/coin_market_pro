# CoinMarketPro

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/coin_market_pro`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Available Endpoints:

* [Cryptocurrency](#### Cryptocurrency)
* [Exchange](#### Exchange)
* [Global Metrics](#### Global Metrics)
* [Tools](#### Global Metrics)

## Installation

Add this line to your application's Gemfile:

`gem 'coin_market_pro'`

And then execute:
`$ bundle`

Or install it yourself as:

`$ gem install coin_market_pro`

## Environment Variables

| Variable                  |  Description          | Default   |
| --------------------------|:----------------------|:---------:|
| `COIN_MARKET_PRO_API_KEY` | CoinMarketCap API Key | -         |

## Usage

### Initialize CoinMarketPro

Client Api Key defaults to `COIN_MARKET_PRO_API_KEY` ENV. Override the client with `api_key` param.

```ruby
  # Rails Example
  #
  # config/initializers/coin_market_pro.rb
  module CoinMarketPro
    Api ||= CoinMarketPro.new(api_key: 'Coinbase-Pro-Api-Key', logger: Rails.logger)
  end

  # Ruby
  client = CoinMarketPro.new(api_key: 'Coinbase-Pro-Api-Key')
```

### [Common Errors](https://pro.coinmarketcap.com/api/v1#section/Errors-and-Rate-Limits)

```
  400 Bad Request
  401 Unauthorized
  403 Forbidden
  429 Too Many Requests
  500 Internal Server Error
```

### Response Format

Response object returned as hash with keys: `status`, `code`, `headers`, `body`, `raw`. For consistency, `body` will always be returned as an array.

```ruby
# Using `client` defined from above

client.cryptocurrency.info(id: [1])
# => #<CoinMarketPro::Client::Result:0x00007f9045657d18
#  @body=
#   [{:urls=>
#      {:website=>["https://bitcoin.org/"],
#       :twitter=>[],
#       :reddit=>["https://reddit.com/r/bitcoin"],
#       :message_board=>["https://bitcointalk.org"],
#       :announcement=>[],
#       :chat=>[],
#       :explorer=>["https://blockchain.info/", "https://live.blockcypher.com/btc/", "https://blockchair.com/bitcoin/blocks"],
#       :source_code=>["https://github.com/bitcoin/"]},
#     :logo=>"https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
#     :id=>1,
#     :name=>"Bitcoin",
#     :symbol=>"BTC",
#     :slug=>"bitcoin",
#     :date_added=>"2013-04-28T00:00:00.000Z",
#     :tags=>["mineable"],
#     :category=>"coin"}],
#  @code=200,
#  @headers=
#   {:content_type=>"application/json; charset=utf-8",
#    :transfer_encoding=>"chunked",
#    :connection=>"keep-alive",
#    :date=>"Mon, 08 Oct 2018 02:04:13 GMT",
#    :server=>"nginx",
#    :vary=>"origin,accept-encoding",
#    :access_control_expose_headers=>"WWW-Authenticate,Server-Authorization",
#    :cache_control=>"no-cache",
#    :content_encoding=>"gzip",
#    :x_cache=>"Miss from cloudfront",
#    :via=>"1.1 39f9e0f028321e95b5ebd1cd55661fd6.cloudfront.net (CloudFront)",
#    :x_amz_cf_id=>"uQcyrXXRjyNb_oFO5hlXDAAX9TgYvmUXUaXujxxzYgRfoq_XleXjhQ=="},
#  @raw=
#   {:status=>{:timestamp=>"2018-10-08T02:04:13.628Z", :error_code=>0, :error_message=>nil, :elapsed=>11, :credit_count=>1},
#    :data=>
#     {:"1"=>
#       {:urls=>
#         {:website=>["https://bitcoin.org/"],
#          :twitter=>[],
#          :reddit=>["https://reddit.com/r/bitcoin"],
#          :message_board=>["https://bitcointalk.org"],
#          :announcement=>[],
#          :chat=>[],
#          :explorer=>
#           ["https://blockchain.info/", "https://live.blockcypher.com/btc/", "https://blockchair.com/bitcoin/blocks"],
#          :source_code=>["https://github.com/bitcoin/"]},
#        :logo=>"https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
#        :id=>1,
#        :name=>"Bitcoin",
#        :symbol=>"BTC",
#        :slug=>"bitcoin",
#        :date_added=>"2013-04-28T00:00:00.000Z",
#        :tags=>["mineable"],
#        :category=>"coin"}}},
#  @status=
#   {:timestamp=>"2018-10-08T02:04:13.628Z",
#    :error_code=>0,
#    :error_message=>nil,
#    :elapsed=>11,
#    :credit_count=>1,
#    :result=>:success}>
```

### Endpoints

#### [Cryptocurrency](https://pro.coinmarketcap.com/api/v1#tag/cryptocurrency)

##### [Info/Metadata](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyInfo)

Returns all static metadata for one or more cryptocurrencies including name, symbol, logo, and its various registered URLs.

- At least one "id" or "symbol" is required as Array.
- Alias method: `#metadata`
- Available API Plans:
  - Basic
  - Startup
  - Hobbyist
  - Standard
  - Professional
  - Enterprise

```ruby
# Using `client` defined from above

result = client.cryptocurrency.info(id: [1]) # cmc.info(symbol: ['BTC'])
result.body

# => [{:urls=>
#    {:website=>["https://bitcoin.org/"],
#     :twitter=>[],
#     :reddit=>["https://reddit.com/r/bitcoin"],
#     :message_board=>["https://bitcointalk.org"],
#     :announcement=>[],
#     :chat=>[],
#     :explorer=>["https://blockchain.info/", "https://live.blockcypher.com/btc/", "https://blockchair.com/bitcoin/blocks"],
#     :source_code=>["https://github.com/bitcoin/"]},
#   :logo=>"https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
#   :id=>1,
#   :name=>"Bitcoin",
#   :symbol=>"BTC",
#   :slug=>"bitcoin",
#   :date_added=>"2013-04-28T00:00:00.000Z",
#   :tags=>["mineable"],
#   :category=>"coin"}]
```

##### [Map](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyMap)

Returns a paginated list of all cryptocurrencies by CoinMarketCap ID.

- Available API Plans:
  - Basic
  - Startup
  - Hobbyist
  - Standard
  - Professional
  - Enterprise

```ruby
client.cryptocurrency.map(symbol: ['BTC']).body

# => [{:id=>1,
#   :name=>"Bitcoin",
#   :symbol=>"BTC",
#   :slug=>"bitcoin",
#   :is_active=>1,
#   :first_historical_data=>"2013-04-28T18:47:21.000Z",
#   :last_historical_data=>"2018-10-16T01:29:00.000Z"}]
```

##### [Listings (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyListingsHistorical)

Returns paginated list of all cryptocurrencies with market data for a given historical time.

* This endpoint is not yet available. It is slated for release in early Q4 2018.

##### [Listings (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyListingsLatest)

Get a paginated list of all cryptocurrencies with latest market data.

- Alias: `#listings_latest`
- Available API Plans:
  - Basic
  - Startup
  - Hobbyist
  - Standard
  - Professional
  - Enterprise

  ```ruby
  client.cryptocurrency.listings(symbol: ['BTC']).body

   # => [{:id=>1,
   #  :name=>"Bitcoin",
   #  :symbol=>"BTC",
   #  :slug=>"bitcoin",
   #  :circulating_supply=>17324362,
   #  :total_supply=>17324362,
   #  :max_supply=>21000000,
   #  :date_added=>"2013-04-28T00:00:00.000Z",
   #  :num_market_pairs=>6324,
   #  :cmc_rank=>1,
   #  :last_updated=>"2018-10-16T01:45:23.000Z",
   #  :quote=>
   #   {:USD=>
   #     {:price=>6584.26049147,
   #      :volume_24h=>7374050978.32602,
   #      :percent_change_1h=>0.0551947,
   #      :percent_change_24h=>4.70272,
   #      :percent_change_7d=>-1.04176,
   #      :market_cap=>114068112256.52419,
   #      :last_updated=>"2018-10-16T01:45:23.000Z"}}},
   # {:id=>1027,
   #  :name=>"Ethereum",
   #  :symbol=>"ETH",
   #  :slug=>"ethereum",
   #  :circulating_supply=>102596461.624,
   #  :total_supply=>102596461.624,
   #  :max_supply=>nil,
   #  :date_added=>"2015-08-07T00:00:00.000Z",
   #  :num_market_pairs=>4473,
   #  :cmc_rank=>2,
   #  :last_updated=>"2018-10-16T01:45:43.000Z",
   #  :quote=>
   #   {:USD=>
   #     {:price=>208.414319714,
   #      :volume_24h=>2838392300.32738,
   #      :percent_change_1h=>0.0524806,
   #      :percent_change_24h=>6.59914,
   #      :percent_change_7d=>-9.22212,
   #      :market_cap=>21382571754.429466,
   #      :last_updated=>"2018-10-16T01:45:43.000Z"}}}]
  ```

##### [Market Pairs](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyMarketpairsLatest)

Lists all market pairs for the specified cryptocurrency with associated stats.

- Available API Plans:
  - Standard
  - Professional
  - Enterprise

```ruby
  client.cryptocurrency.market_pairs(symbol: ['BTC']).body
```

##### [OHLCV (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyOhlcvHistorical)

Return an interval of historic OHLCV (Open, High, Low, Close, Volume) market quotes for a cryptocurrency.

- Available API Plans:
  - Standard (1 month)
  - Professional (12 months)
  - Enterprise (Up to 5 years)

```ruby
  client.cryptocurrency.ohlcv_historical(id: [1]).body
```

##### [OHLCV (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyOhlcvLatest)

Return an interval of historic OHLCV (Open, High, Low, Close, Volume) market quotes for a cryptocurrency.

- Alias `#ohlcv_latest`
- Available API Plans:
  - Startup
  - Hobbyist
  - Standard
  - Professional
  - Enterprise

```ruby
  client.cryptocurrency.ohlcv_historical(id: [1]).body
```

##### [Market Quotes (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyQuotesHistorical)

Returns an interval of historic market quotes for any cryptocurrency based on time and interval parameters.

- One "id" or "symbol" is required.
- Alias: `#market_quotes_historical`
- Available API Plans:
  - Standard (1 month)
  - Professional (12 months)
  - Enterprise (Up to 5 years)

```ruby
  client.cryptocurrency.quotes_historical(id: 1).body
```

##### [Market Quotes (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyQuotesLatest)

Get the latest market quote for 1 or more cryptocurrencies. Use the "convert" option to return market values in multiple fiat and cryptocurrency conversions in the same call.

- At least one "id" or "symbol" is required.
- Alias: `#market_quotes, #quotes_latest`
- Available API Plans:
  - Basic
  - Hobbyist
  - Startup
  - Standard
  - Professional
  - Enterprise

```ruby
  client.cryptocurrency.quotes(id: [1]).body
```

#### [Exchange](https://pro.coinmarketcap.com/api/v1#tag/exchange)

##### [Info/Metadata](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeInfo)

Returns all static metadata for one or more exchanges including logo and homepage URL.

- Alias: `#market_quotes, #quotes_latest`
- Available API Plans:
  - Startup
  - Standard
  - Professional
  - Enterprise

```ruby
  client.exchange.info(id: [1]).body
```

##### [Map](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeMap)

Returns a paginated list of all cryptocurrency exchanges by CoinMarketCap ID. We recommend using this convenience endpoint to lookup and utilize our unique exchange id across all endpoints as typical exchange identifiers may change over time.

- Available API Plans:
  - Startup
  - Standard
  - Professional
  - Enterprise

```ruby
  client.exchange.map.body
```

##### [Listings (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeListingsHistorical)

Get a paginated list of all cryptocurrency exchanges with historical market data for a given point in time.

```ruby
  client.exchange.listings_historical
```

##### [Listings (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeListingsLatest)

Get a paginated list of all cryptocurrency exchanges with 24 hour volume. Additional market data fields will be available in the future.

- Alias: `#listings_latest`
- Available API Plans:
  - Standard
  - Professional
  - Enterprise

```ruby
  client.exchange.listings
```

##### [Market Pairs](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeMarketpairsLatest)

Get a list of active market pairs for an exchange. Active means the market pair is open for trading.

- Available API Plans:
  - Standard
  - Professional
  - Enterprise

```ruby
  client.exchange.market_pairs(id: [1])
```

##### [Market Quotes (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeQuotesHistorical)

Returns an interval of historic quotes for any exchange based on time and interval parameters.

- Available API Plans:
  - Standard (1 Month)
  - Professional (12 Months)
  - Enterprise (Up to 5 Years)

```ruby
  client.exchange.quotes_historical(id: [1])
```

##### [Market Quotes (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeQuotesLatest)

Get the latest 24 hour volume quote for 1 or more exchanges. Additional market data fields will be available in the future.

- Available API Plans:
  - Standard
  - Professional
  - Enterprise

```ruby
  client.exchange.quotes(id: [1, 2])
```

#### [Global Metrics](https://pro.coinmarketcap.com/api/v1#tag/global-metrics)

##### [Quotes (Historical)](https://pro.coinmarketcap.com/api/v1#operation/getV1GlobalmetricsQuotesHistorical)

Get an interval of aggregate 24 hour volume and market cap data globally based on time and interval parameters.

- Available API Plans:
  - Standard (1 month)
  - Professional (12 months)
  - Enterprise (Up to 5 years)

```ruby
  client.global_metrics.quotes_historical
```

##### [Quotes (Latest)](https://pro.coinmarketcap.com/api/v1#operation/getV1GlobalmetricsQuotesLatest)

Get the latest quote of aggregate market metrics. Use the "convert" option to return market values in multiple fiat and cryptocurrency conversions in the same call.

- Available API Plans:
  - Basic
  - Hobbyist
  - Startup
  - Standard
  - Professional
  - Enterprise


```ruby
  client.global_metrics.quotes
```

#### [Tools](https://pro.coinmarketcap.com/api/v1#tag/tools)

##### [Price conversion](https://pro.coinmarketcap.com/api/v1#operation/getV1ToolsPriceconversion)

Convert an amount of one currency into up to 32 other cryptocurrency or fiat currencies at the same time using latest exchange rates. Optionally pass a historical timestamp to convert values based on historic averages.

- Available API Plans:
  - Basic
  - Hobbyist
  - Startup
  - Standard
  - Professional
  - Enterprise

  ```ruby
    client.tools.price_conversion(amount: 10.43, id: [1])
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/coin_market_pro.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
