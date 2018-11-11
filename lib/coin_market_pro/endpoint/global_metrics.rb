# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    # @see https://pro.coinmarketcap.com/api/v1#tag/exchange
    class GlobalMetrics < Base
      ENDPOINT = '/global-metrics'

      # Get an interval of aggregate 24 hour volume and market cap data globally based on time and interval parameters.
      #
      # @param [Hash] args
      # @option args [String] :time_start
      # @option args [String] :time_end
      # @option args [Number] :count
      # @option args [String] :interval
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ExchangeQuotesHistorical
      def quotes_historical(**args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/quotes/historical", options: params.compact).tap do |resp|
          resp.body = resp.body[:quotes]
        end
      end

      alias market_quotes_historical quotes_historical

      # Get the latest quote of aggregate market metrics.
      #  Use the "convert" option to return market values in multiple fiat and cryptocurrency conversions in the same call.
      #
      # @param [Hash] args
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1GlobalmetricsQuotesLatest
      def quotes(**args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/quotes/latest", options: params.compact).tap do |resp|
          resp.body = [resp.body]
        end
      end

      alias market_quotes quotes
      alias quotes_latest quotes
    end
  end
end
