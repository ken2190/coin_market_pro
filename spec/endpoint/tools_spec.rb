# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Endpoint::Tools do
  let(:api_key) { 'CoinMarketCap-Api-Key' }
  let(:client) { CoinMarketPro::Client::Base.new(api_key: api_key) }
  let(:subject) { described_class.new(client: client, logger: client.logger) }
  let(:uri) { '/tools' }

  describe '#quotes_historical' do
    let(:endpoint) { uri + '/price-conversion' }

    before(:each) do
      stub_request(:get, /#{endpoint}/).and_return(body: fixture('tools/price_conversion.json'))
    end

    it 'returns successful results' do
      result = subject.price_conversion(amount: 1, id: [1])

      expect(a_request(:get, /#{endpoint}/)).to have_been_made
      expect(result).to be_a CoinMarketPro::Client::Result
      expect(result.success?).to eq(true)
      expect(result.code).to eq(200)
      expect(result.status).to include(result: :success)
      expect(result.body).to be_a(Array)
    end

    it 'raises error when invalid params (amount)' do
      expect { subject.price_conversion(foo: 1) }
        .to raise_error(ArgumentError, 'amount is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end

    it 'raises error when invalid params' do
      expect { subject.price_conversion(amount: 1) }
        .to raise_error(ArgumentError, 'At least one "id" or "slug" is required.')
      expect(a_request(:get, /#{endpoint}/)).not_to have_been_made
    end
  end
end
