# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Client::Result do # rubocop:disable Metrics/BlockLength
  let(:response) { double('response') }
  let(:code) { double('code') }
  let(:body) do
    {
      data: {
        test: 'test'
      },
      status: {
        code: 0
      }
    }
  end
  let(:headers) do
    {
      content_type: 'application/json'
    }
  end

  before(:each) do
    allow(response).to receive(:body).and_return(body.to_json)
    allow(response).to receive(:code).and_return(code)
    allow(response).to receive(:headers).and_return(headers)
  end

  describe '.success' do
    it 'captures response and sets status to success' do
      result = described_class.success(response)

      expect(result).to be_a(CoinMarketPro::Client::Result)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.body).to eq(body[:data])
      expect(result.code).to eq(code)
    end
  end

  describe '.failed' do
    it 'captures response and sets status to failed' do
      result = described_class.failed(response)

      expect(result).to be_a(CoinMarketPro::Client::Result)
      expect(result.success?).to eq(false)
      expect(result.failure?).to eq(true)
      expect(result.body).to eq(body[:data])
      expect(result.code).to eq(code)
    end
  end

  describe '#success?' do
    let(:result) { described_class.success(response) }

    it 'returns true if success' do
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
    end
  end

  describe '#failure?' do
    let(:result) { described_class.failed(response) }

    it 'returns true if failed' do
      expect(result.failure?).to eq(true)
      expect(result.success?).to eq(false)
    end
  end

  describe '#to_h' do
    it 'returns a hash of values' do
      result = described_class.success(response)
      expect(result.to_h).to eq(code: code, headers: headers, body: body[:data], status: body[:status].merge(result: :success))
    end
  end

  describe '#to_hash' do
    it 'returns a hash of values' do
      result = described_class.success(response)
      expect(result.to_hash).to eq(code: code, headers: headers, body: body[:data], status: body[:status].merge(result: :success))
    end

    it 'can be called implicitly' do
      result = described_class.success(response)
      expect(result[:code]).to eq code
    end
  end
end
