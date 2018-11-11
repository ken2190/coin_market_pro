# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CoinMarketPro::Endpoint::Base do
  let(:api_key) { 'CoinMarketCap-Api-Key' }
  let(:client) { CoinMarketPro::Client::Base.new(api_key: api_key) }
  let(:subject) { described_class.new(client: client, logger: client.logger) }

  describe '#valid_params?' do
    it 'returns true when valid' do
      args = { id: 1 }
      expect(subject.send(:valid_params?, args)).to eq(true)
    end

    it 'raises error when invalid' do
      args = { foo: 1 }
      expect { subject.send(:valid_params?, args) }
        .to raise_error(ArgumentError, 'At least one "id" or "symbol" is required.')
    end
  end

  describe '#convert_params' do
    it 'returns standardized params' do
      params = { foo: [1, 2, 3], bar: ' 4,5,6 ', baz: 13.0 }

      expect(subject.send(:convert_params, params))
        .to eq(foo: '1,2,3', bar: '4,5,6', baz: 13.0)
    end

    it 'returns empty hash if blank' do
      expect(subject.send(:convert_params)).to eq({})
    end
  end

  describe '#standardize_value' do
    it 'returns formatted value (Array)' do
      expect(subject.send(:standardize_value, ['hi', 1])).to eq('hi,1')
    end

    it 'returns formatted value (String)' do
      expect(subject.send(:standardize_value, ' i haz crypto! ')).to eq('i haz crypto!')
    end

    it 'returns passthrough value (Numeric)' do
      expect(subject.send(:standardize_value, 133.54)).to eq(133.54)
    end
  end
end
