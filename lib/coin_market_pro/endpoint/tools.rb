# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    # @see https://pro.coinmarketcap.com/api/v1#tag/exchange
    class Tools < Base
      ENDPOINT = '/tools'

      # Convert an amount of one currency into up to 32 other cryptocurrency or fiat currencies
      #   at the same time using latest exchange rates.
      #   Optionally pass a historical timestamp to convert values based on historic averages.
      #
      # @param [Hash] args
      # @option args [Number] :amount
      # @option args [Array<Integer>] :id
      # @option args [Array<String>] :symbol
      # @option args [String] :time
      # @option args [String] :convert
      # @return [CoinMarketPro::Result]
      #
      # @see https://pro.coinmarketcap.com/api/v1#operation/getV1ToolsPriceconversion
      def price_conversion(**args)
        valid_params?(args)
        params = convert_params(args)
        client.get("#{ENDPOINT}/price-conversion", options: params.compact).tap do |resp|
          resp.body = [resp.body]
        end
      end

      protected

      # @param args [Hash]
      # @return [Boolean]
      # @raise [ArgumentError]
      def valid_params?(args)
        raise ArgumentError.new('amount is required.') if args[:amount].blank?
        raise ArgumentError.new('At least one "id" or "slug" is required.') if args[:id].blank? && args[:slug].blank?

        true
      end
    end
  end
end
