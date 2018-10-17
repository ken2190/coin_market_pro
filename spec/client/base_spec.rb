# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Client::Base do # rubocop:disable Metrics/BlockLength
  let(:host) { 'https://pro-api.coinmarketcap.com/v1' }
  let(:api_key) { 'CoinMarketCap-Api-Key' }
  let(:path) { '/test' }
  let(:subject) { described_class.new(api_key: api_key) }

  describe '.configuration' do
    it 'has host' do
      expect(subject.host).to eq(host)
    end

    it 'has api_key' do
      expect(subject.api_key).to eq(api_key)
    end

    it 'has default logger' do
      expect(subject.logger).to be_a(Logger)
    end

    it 'raises error when api_key missing' do
      expect { described_class.new }.to raise_error(KeyError, 'key not found: "COIN_MARKET_PRO_API_KEY"')
    end
  end

  describe '.default_headers' do
    it do
      expect(subject.default_headers).to eq(
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'User-Agent' => "coin_market_pro/#{CoinMarketPro::VERSION}",
        'Accept-Encoding' => 'deflate, gzip',
        'X-CMC_PRO_API_KEY' => api_key
      )
    end
  end

  describe '.open_timeout' do
    it { expect(subject.open_timeout).to eq(10) }
  end

  describe '.timeout' do
    it { expect(subject.timeout).to eq(10) }
  end

  describe '.handle_error' do
    let(:response) { double('response') }
    let(:error) { double('error') }
    let(:code) { 400 }
    let(:body) do
      {
        data: { id: 1 },
        status: { code: code }
      }
    end

    it 'returns failure status response' do
      allow(response).to receive(:headers)
      allow(response).to receive(:body).and_return(body.to_json)
      expect(response).to receive(:code).at_least(:once).and_return(code)

      expect(error).to receive(:message).and_return('message')
      expect(error).to receive(:response).and_return(response)

      status = subject.handle_error(error)

      expect(status.failure?).to eq(true)
    end
  end

  describe '.get' do
    let(:response) { double('response') }
    let(:body) do
      {
        data: { id: 1 },
        status: { code: 200 }
      }
    end

    before do
      allow(RestClient::Request).to receive(:execute).and_return(response)
      allow(response).to receive(:body).and_return(body.to_json)
      allow(response).to receive(:headers)
    end

    it 'returns successful status response' do
      expect(response).to receive(:code).at_least(:once).and_return(200)

      status = subject.get(path)
      expect(status.success?).to eq(true)
    end

    context 'error' do
      it 'returns failure status response' do
        expect(response).to receive(:code).at_least(:once).and_return(400)

        status = subject.get(path)
        expect(status.failure?).to eq(true)
      end
    end
  end
end
