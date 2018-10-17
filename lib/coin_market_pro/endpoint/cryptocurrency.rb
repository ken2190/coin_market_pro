# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    # @see https://pro.coinmarketcap.com/api/v1#tag/cryptocurrency
    class Cryptocurrency < Base
      ENDPOINT = '/cryptocurrency'

      # Returns all static metadata for one or more cryptocurrencies
      #  including name, symbol, logo, and its various registered URLs.
      #
      # @param [Hash] args
      # @option args [Array<Integer>] :id One or more CoinMarketCap cryptocurrency IDs.
      # @option args [Array<String>] :symbol Alternatively pass one or more cryptocurrency symbols.
      # @return [CoinMarketPro::Result]
      # @note At least one "id" or "symbol" is required.
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyInfo
      ##
      def info(**args)
        valid_params?(args)
        params = required_params(args)

        resp = client.get("#{ENDPOINT}/info", options: params.compact)
        resp.body = resp.body.map { |_k, data| data }
        resp
      rescue NoMethodError => e
        logger.error(endpoint: "#{ENDPOINT}/info", error: e.message, id: args[:id], symbol: args[:symbol])
        raise ArgumentError.new('Argument must be an array')
      end

      alias metadata info

      # Returns a paginated list of all cryptocurrencies by CoinMarketCap ID.
      #
      # @param [Hash] args
      # @option args [String] :listing_status Only active coins are returned by default.
      #  Pass 'inactive' to get a list of coins that are no longer active.
      # @option args [Integer] :start Optionally offset the start (1-based index) of the paginated list of items to return.
      # @option args [Integer] :limit Optionally specify the number of results to return.
      #  Use this parameter and the "start" parameter to determine your own pagination size.
      # @option args [Array] :symbol Optionally pass a list of cryptocurrency symbols to return
      #  CoinMarketCap IDs for. If this option is passed, other options will be ignored.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyMap
      ##
      def map(**args)
        valid_params?(args)
        client.get("#{ENDPOINT}/map", options: args.compact)
      end

      # @note This endpoint is not yet available. It is slated for release in early Q4 2018.
      # Returns paginated list of all cryptocurrencies with market data for a given historical time.
      #
      # @option timestamp [String] Timestamp (Unix or ISO 8601) to return historical cryptocurrency listings for.
      # @option start [Integer] Optionally offset the start (1-based index) of the paginated list of items to return.
      # @option limit [Integer] Optionally specify the number of results to return. Use this parameter
      #  and the "start" parameter to determine your own pagination size.
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols. Each additional convert option beyond the
      #  first requires an additional call credit. A list of supported fiat options can be found here. Each conversion
      #  is returned in its own "quote" object.
      # @option sort [String] What field to sort the list of cryptocurrencies by.
      # @option sort_dir [String] The direction in which to order cryptocurrencies against the specified sort.
      # @option cryptocurrency_type [String] The type of cryptocurrency to include.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyListingsHistorical
      ##
      def listings_historical(**args)
        client.get("#{ENDPOINT}/listings/historical", options: args.compact)
      end

      # Get a paginated list of all cryptocurrencies with latest market data.
      #
      # @option timestamp [String] Timestamp (Unix or ISO 8601) to return historical cryptocurrency listings for.
      # @option start [Integer] Optionally offset the start (1-based index) of the paginated list of items to return.
      # @option limit [Integer] Optionally specify the number of results to return. Use this parameter
      #  and the "start" parameter to determine your own pagination size.
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols. Each additional convert option beyond the
      #  first requires an additional call credit. A list of supported fiat options can be found here. Each conversion
      #  is returned in its own "quote" object.
      # @option sort [String] What field to sort the list of cryptocurrencies by.
      # @option sort_dir [String] The direction in which to order cryptocurrencies against the specified sort.
      # @option cryptocurrency_type [String] The type of cryptocurrency to include.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyListingsLatest
      ##
      def listings(**args)
        client.get("#{ENDPOINT}/listings/latest", options: args.compact)
      end

      alias listings_latest listings

      # Lists all market pairs for the specified cryptocurrency with associated stats.
      #
      # @option id [String] A cryptocurrency by CoinMarketCap ID. Example: "1"
      # @option symbol [String] Alternatively pass a cryptocurrency by symbol. Example: "BTC".
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option start [Integer] Optionally offset the start (1-based index) of the paginated list of items to return.
      # @option limit [Integer] Optionally specify the number of results to return.
      #  Use this parameter and the "start" parameter to determine your own pagination size.
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols.
      #  Each additional convert option beyond the first requires an additional call credit.
      #  A list of supported fiat options can be found here. Each conversion is returned in its own "quote" object.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyMarketpairsLatest
      ##
      def market_pairs(**args)
        valid_params?(args)
        params = required_params(args)
        client.get("#{ENDPOINT}/market-pairs/latest", options: params.compact)
      end

      # Return an interval of historic OHLCV (Open, High, Low, Close, Volume) market quotes for a cryptocurrency.
      #
      # @option id [String] A cryptocurrency by CoinMarketCap ID. Example: "1"
      # @option symbol [String] Alternatively pass a cryptocurrency by symbol. Example: "BTC".
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option time_period [String] Time period to return OHLCV data for. The default is "daily".
      #  Additional options will be available in the future. See the main endpoint description for details.
      # @option time_start [String] Timestamp (Unix or ISO 8601) to start returning OHLCV time periods for.
      #  Only the date portion of the timestamp is used for daily OHLCV so it's recommended to send an ISO date
      #  format like "2018-09-19" without time.
      # @option time_end [String] Timestamp (Unix or ISO 8601) to stop returning OHLCV time periods for (inclusive).
      #  Optional, if not passed we'll default to the current time. Only the date portion of the timestamp is used for
      #  daily OHLCV so it's recommended to send an ISO date format like "2018-09-19" without time.
      # @option count [Number] Optionally limit the number of time periods to return results for.
      #  The default is 10 items. The current query limit is 10000 items.
      # @option interval [String] Optionally adjust the interval that "time_period" is sampled.
      #  See main endpoint description for available options.
      #  Valid Values: "daily" "weekly" "monthly" "yearly" "1d" "2d" "3d" "7d" "14d" "15d" "30d" "60d" "90d" "365d"
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols.
      #  Each additional convert option beyond the first requires an additional call credit.
      #  A list of supported fiat options can be found here. Each conversion is returned in its own "quote" object.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyOhlcvHistorical
      ##
      def ohlcv_historical(**args)
        valid_params?(args)
        params = required_params(args)
        client.get("#{ENDPOINT}/ohlcv/historical", options: params.compact)
      end

      # Return the latest OHLCV (Open, High, Low, Close, Volume) market values for one or
      #  more cryptocurrencies in the currently UTC day.
      #
      # @option id [String] A cryptocurrency by CoinMarketCap ID. Example: "1"
      # @option symbol [String] Alternatively pass a cryptocurrency by symbol. Example: "BTC".
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols.
      #  Each additional convert option beyond the first requires an additional call credit.
      #  A list of supported fiat options can be found here. Each conversion is returned in its own "quote" object.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyOhlcvLatest
      def ohlcv(**args)
        valid_params?(args)
        params = required_params(args)
        client.get("#{ENDPOINT}/ohlcv/latest", options: params.compact)
      end

      alias ohlcv_latest ohlcv

      # Returns an interval of historic market quotes for any cryptocurrency based on time and interval parameters.
      #
      # @option id [String] A cryptocurrency by CoinMarketCap ID. Example: "1"
      # @option symbol [String] Alternatively pass a cryptocurrency by symbol. Example: "BTC".
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option time_period [String] Time period to return OHLCV data for. The default is "daily".
      #  Additional options will be available in the future. See the main endpoint description for details.
      # @option time_start [String] Timestamp (Unix or ISO 8601) to start returning OHLCV time periods for.
      #  Only the date portion of the timestamp is used for daily OHLCV so it's recommended to send an ISO date
      #  format like "2018-09-19" without time.
      # @option time_end [String] Timestamp (Unix or ISO 8601) to stop returning OHLCV time periods for (inclusive).
      #  Optional, if not passed we'll default to the current time. Only the date portion of the timestamp is used for
      #  daily OHLCV so it's recommended to send an ISO date format like "2018-09-19" without time.
      # @option count [Number] Optionally limit the number of time periods to return results for.
      #  The default is 10 items. The current query limit is 10000 items.
      # @option interval [String] Optionally adjust the interval that "time_period" is sampled.
      #  See main endpoint description for available options.
      #  Valid Values: "daily" "weekly" "monthly" "yearly" "1d" "2d" "3d" "7d" "14d" "15d" "30d" "60d" "90d" "365d"
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols.
      #  Each additional convert option beyond the first requires an additional call credit.
      #  A list of supported fiat options can be found here. Each conversion is returned in its own "quote" object.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyQuotesHistorical
      def quotes_historical
        valid_params?(args)
        params = required_params(args)
        client.get("#{ENDPOINT}/quotes/historical ", options: params.compact)
      end

      alias market_quotes_historical quotes_historical

      # @option id [Array<String>] One or more comma-separated cryptocurrency CoinMarketCap IDs. Example: 1,2
      # @option symbol [String] Alternatively pass a cryptocurrency by symbol. Example: "BTC,ETH".
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option convert [String] Optionally calculate market quotes in up to 32 currencies at once by passing a
      #  comma-separated list of cryptocurrency or fiat currency symbols.
      #  Each additional convert option beyond the first requires an additional call credit.
      #  A list of supported fiat options can be found here. Each conversion is returned in its own "quote" object.
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyQuotesLatest
      def quotes
        valid_params?(args)
        params = required_params(args)
        client.get("#{ENDPOINT}/quotes/historical ", options: params.compact)
      end

      alias market_quotes quotes
      alias quotes_latest quotes
    end
  end
end
