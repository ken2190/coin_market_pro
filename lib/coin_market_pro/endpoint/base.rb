# frozen_string_literal: true

module CoinMarketPro
  module Endpoint
    class Base
      attr_reader :client, :logger

      def initialize(client:, logger:)
        @client = client
        @logger = logger
      end

      protected

      # @param args [Hash]
      # @return [Boolean]
      # @raise [ArgumentError]
      def valid_params?(args)
        raise ArgumentError.new('At least one "id" or "symbol" is required.') if args[:id].blank? && args[:symbol].blank?

        true
      end

      private

      # Convert/Standardize base params
      # @param params [Hash]
      # @return [Hash]
      def convert_params(**params)
        return {} if params.blank?

        params.each { |k, v| params[k] = standardize_value(v) }
        params
      end

      # Standardize request params
      def standardize_value(param)
        if param.is_a?(Array)
          param.join(',')
        elsif param.is_a?(String)
          param.strip
        else
          param
        end
      end
    end
  end
end
