# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Endpoint::GlobalMetrics do
  let(:api_key) { 'CoinMarketCap-Api-Key' }
  let(:client) { CoinMarketPro::Client::Base.new(api_key: api_key) }
  let(:subject) { described_class.new(client: client, logger: client.logger) }
  let(:uri) { '/global-metrics' }

  describe '#quotes_historical' do
    let(:endpoint) { uri + '/quotes/historical' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('global_metrics/quotes_historical.json'))
    end

    it 'returns successful results' do
      result = subject.quotes_historical(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'alias market_quotes_historical returns successful results' do
      result = subject.market_quotes_historical(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end
  end

  describe '#quotes' do
    let(:endpoint) { uri + '/quotes/latest' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('global_metrics/quotes.json'))
    end

    it 'returns successful results' do
      result = subject.quotes(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'alias market_quotes returns successful results' do
      result = subject.market_quotes(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'alias quotes_latest returns successful results' do
      result = subject.quotes_latest(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end
  end
end
