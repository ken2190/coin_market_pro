# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    # @see https://pro.coinmarketcap.com/api/v1#tag/exchange
    class Exchange < Base
      ENDPOINT = '/exchange'

      # Returns all static metadata for one or more exchanges including logo and homepage URL.
      #
      # @param [Hash] args
      # @option args [Array<Integer>] :id
      # @option args [Array<String>] :slug
      # @return [CoinMarketPro::Result]
      # @note At least one "id" or "slug" is required.
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeInfo
      ##
      def info(**args)
        valid_params?(args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/info", options: params.compact).tap do |resp|
          resp.body = resp.body.map { |_k, data| data }
        end
      end

      alias metadata info

      # @note This endpoint is not yet available. It is slated for release in early Q4 2018.
      # Get a paginated list of all cryptocurrency exchanges with historical market data for a given point in time.
      #
      # @param args [Hash]
      # @option args [String] :timestamp
      # @option args [Integer] :start
      # @option args [Integer] :limit
      # @option args [String] :convert
      # @option args [String] :sort
      # @option args [String] :sort_dir
      # @option args [String] :market_type Default: 'fees'. Valid values: 'fees', 'no_fees', 'all'
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeListingsHistorical
      ##
      def listings_historical(**args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/listings/historical", options: params.compact)
      end

      # Get a paginated list of all cryptocurrency exchanges with 24 hour volume.
      #
      # @param args [Hash]
      # @option args [String] :timestamp
      # @option args [Integer] :start
      # @option args [Integer] :limit
      # @option args [String] :convert
      # @option args [String] :sort
      # @option args [String] :sort_dir
      # @option args [String] :market_type Default: 'fees'. Valid values: 'fees', 'no_fees', 'all'
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeListingsLatest
      ##
      def listings(**args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/listings/latest", options: params.compact)
      end

      alias listings_latest listings

      # Returns a paginated list of all cryptocurrencies by CoinMarketCap ID.
      #
      # @param [Hash] args
      # @option args [String] :listing_status Optional. Defaults to 'active'
      # @option args [Integer] :start
      # @option args [Integer] :limit
      # @option args [Array] :slug
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeMap
      ##
      def map(**args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/map", options: params.compact)
      end

      # Get a list of active market pairs for an exchange.
      #
      # @param [Hash] args
      # @option args [Array<Integer>] :id
      # @option args [Array<String>] :slug
      # @option args [Integer] :start
      # @option args [Integer] :limit
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeMarketpairsLatest
      ##
      def market_pairs(**args)
        valid_params?(args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/market-pairs/latest", options: params.compact).tap do |resp|
          resp.body = [resp.body]
        end
      end

      # Returns an interval of historic quotes for any exchange based on time and interval parameters.
      #
      # @param [Hash] args
      # @option args [Array<Integer>] :id
      # @option args [Array<String>] :slug
      #  A single cryptocurrency "id" or "symbol" is required.
      # @option args [String] :time_period
      # @option args [String] :time_start
      # @option args [String] :time_end
      # @option args [Number] :count
      # @option args [String] :interval
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeQuotesHistorical
      def quotes_historical(**args)
        valid_params?(args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/quotes/historical", options: params.compact).tap do |resp|
          resp.body = [resp.body]
        end
      end

      alias market_quotes_historical quotes_historical

      # @param [Hash] args
      # @option args [Array<Integer>] :id
      # @option args [Array<String>] :slug
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeQuotesLatest
      def quotes(**args)
        valid_params?(args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/quotes/latest", options: params.compact).tap do |resp|
          resp.body = resp.body.map { |_k, data| data }
        end
      end

      alias market_quotes quotes
      alias quotes_latest quotes

      protected

      # @param args [Hash]
      # @return [Boolean]
      # @raise [ArgumentError]
      def valid_params?(args)
        raise ArgumentError.new('At least one "id" or "slug" is required.') if args[:id].blank? && args[:slug].blank?

        true
      end
    end
  end
end
