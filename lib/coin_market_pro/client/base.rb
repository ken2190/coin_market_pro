# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/object'
require 'rest_client'

require_relative './result'
Dir['./lib/coin_market_pro/endpoint/**/*.rb'].each { |f| require f }

module CoinMarketPro
  module Client
    class Error < RuntimeError
      def initialize(message)
        super(message)
      end
    end

    class Base
      attr_reader :host, :api_key, :logger, :cryptocurrency, :exchange, :global_metrics, :tools

      API_DOMAIN = 'https://pro-api.coinmarketcap.com'
      API_VERSION = 'v1'
      API_URL = "#{API_DOMAIN}/#{API_VERSION}"
      DEFAULT_TIMEOUT = 10

      def initialize(api_key: ENV.fetch('COIN_MARKET_PRO_API_KEY'), logger: Logger.new(STDOUT), timeout: DEFAULT_TIMEOUT)
        @host = API_URL
        @api_key = api_key
        @logger = logger
        @timeout = timeout

        # services
        @cryptocurrency = Endpoint::Cryptocurrency.new(client: self, logger: @logger)
        @exchange = Endpoint::Exchange.new(client: self, logger: @logger)
        @global_metrics = Endpoint::GlobalMetrics.new(client: self, logger: @logger)
        @tools = Endpoint::Tools.new(client: self, logger: @logger)
      end

      # GET request
      #
      # @param uri [String]
      # @param options [Hash]
      # @param headers [Hash]
      # @return [Result]
      def get(uri, options: {}, headers: {})
        request do
          url = host + uri
          options ||= {}
          headers ||= {}

          query_params = CGI.unescape(options.to_query)
          url += '?' + query_params unless query_params.blank?

          response = RestClient::Request.execute(method: :get,
                                                 url: url,
                                                 headers: default_headers.merge(headers),
                                                 open_timeout: open_timeout,
                                                 timeout: timeout)

          logger.debug(message: 'GET Request', url: url, options: options, status: response.code)
          success?(response.code) ? Result.success(response) : Result.failed(response)
        end
      end

      # @yield [Result]
      def request
        result = yield

        if result.success?
          logger.debug(status: result.code, body: result.body)
        else
          logger.warn(error: 'Request Error', status: result.code, body: result.body)
        end

        result
      rescue ::RestClient::GatewayTimeout
        raise Error.new('Gateway timeout')
      rescue ::RestClient::RequestTimeout
        raise Error.new('Request timeout')
      rescue ::RestClient::Exception => e
        handle_error(e)
      end

      # Handle errors
      # @param error [Error]
      # @return [Result]
      def handle_error(error)
        response = error.response
        message = error.message
        logger.error(error: 'Request Error', code: response.code, message: message)
        Result.failed(response)
      end

      # @return [Hash]
      def default_headers
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => "coin_market_pro/#{CoinMarketPro::VERSION}",
          'Accept-Encoding' => 'deflate, gzip',
          'X-CMC_PRO_API_KEY' => api_key
        }
      end

      # @return [Integer]
      def timeout
        @timeout || DEFAULT_TIMEOUT
      end

      # @return [Integer]
      def open_timeout
        @open_timeout || DEFAULT_TIMEOUT
      end

      private

      # @return [Boolean]
      def success?(status_code = 0)
        return true if status_code.in?(200..299)

        false
      end
    end
  end
end
