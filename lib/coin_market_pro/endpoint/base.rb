# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    class Base
      attr_reader :client, :logger

      def initialize(client:, logger:)
        @client = client
        @logger = logger
      end

      private

      # @param args [Hash]
      # @return [Boolean]
      # @raise [ArgumentError]
      def valid_params?(args)
        raise ArgumentError.new('At least one "id" or "symbol" is required.') if args[:id].blank? && args[:symbol].blank?
        true
      end

      def required_params(**params)
        %i[id symbol].each { |x| params[x] = standardize_params(params[x]) }
        params
      end

      def standardize_params(param)
        if param.is_a?(Array)
          param.join(',')
        elsif param.is_a?(String)
          param.strip
        end
      end
    end
  end
end
