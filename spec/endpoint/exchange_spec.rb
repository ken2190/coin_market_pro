# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Endpoint::Exchange do
  let(:api_key) { 'CoinMarketCap-Api-Key' }
  let(:client) { CoinMarketPro::Client::Base.new(api_key: api_key) }
  let(:subject) { described_class.new(client: client, logger: client.logger) }
  let(:uri) { '/exchange' }

  describe '#info' do
    let(:endpoint) { uri + '/info' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/info.json'))
    end

    it 'returns successful results' do
      result = subject.info(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'metadata alias returns successful results' do
      result = subject.metadata(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'raises error when invalid params' do
      expect { subject.info(foo: 1) }
        .to raise_error(ArgumentError, 'At least one "id" or "slug" is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end
  end

  describe '#listings_historical' do
    let(:endpoint) { uri + '/listings/historical' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/listings_historical.json'))
    end

    it 'returns successful results' do
      result = subject.listings_historical

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end
  end

  describe '#listings' do
    let(:endpoint) { uri + '/listings/latest' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/listings.json'))
    end

    it 'returns successful results' do
      result = subject.listings

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'alias listings_latest returns successful results' do
      result = subject.listings_latest

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end
  end

  describe '#map' do
    let(:endpoint) { uri + '/map' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/map.json'))
    end

    it 'returns successful results' do
      result = subject.map

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end
  end

  describe '#market_pairs' do
    let(:endpoint) { uri + '/market-pairs/latest' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/market_pairs.json'))
    end

    it 'returns successful results' do
      result = subject.market_pairs(id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'raises error when invalid params' do
      expect { subject.market_pairs(foo: 1) }.to raise_error(ArgumentError, 'At least one "id" or "slug" is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end
  end

  describe '#quotes_historical' do
    let(:endpoint) { uri + '/quotes/historical' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/quotes_historical.json'))
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

    it 'raises error when invalid params' do
      expect { subject.quotes_historical(foo: 1) }
        .to raise_error(ArgumentError, 'At least one "id" or "slug" is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end
  end

  describe '#quotes' do
    let(:endpoint) { uri + '/quotes/latest' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('exchange/quotes.json'))
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

    it 'raises error when invalid params' do
      expect { subject.quotes(foo: 1) }
        .to raise_error(ArgumentError, 'At least one "id" or "slug" is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end
  end
end
