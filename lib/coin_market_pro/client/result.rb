# frozen_string_literal: true

module CoinMarketPro
  module Client
    ##
    # Status object to capture result from an HTTP request
    #
    # Gives callers context of the result and allows them to
    # implement successful strategies to handle success/failure
    #
    class Result
      def self.success(response)
        new(:success, response)
      end

      def self.failed(response)
        new(:failed, response)
      end

      attr_reader :status, :code, :headers, :raw
      attr_accessor :body

      def initialize(status, response)
        @raw = raw_parse(response.body)
        @status = @raw[:status]&.merge(result: status) || { result: status }
        @code = response.code
        @body = @raw[:data]
        @headers = response.headers # e.g. "Content-Type" will become :content_type.
      end

      def success?
        @status[:result] == :success
      end

      def failure?
        @status[:result] == :failed
      end

      def to_h
        { status: @status, code: @code, headers: @headers, body: @body }
      end

      alias to_hash to_h

      def method_missing(method, *args, &blk)
        to_h.send(method, *args, &blk)
      end

      def respond_to_missing?(method, include_private = false)
        to_h.respond_to?(method) || super
      end

      # @param body [JSON] Raw JSON body
      def raw_parse(body)
        JSON.parse(body, symbolize_names: true)
      rescue StandardError => e
        raise ResponseBodyParseError.new(error: 'JSON parse error', message: e.message, body: body)
      end

      class ResponseBodyParseError < StandardError; end
    end
  end
end
