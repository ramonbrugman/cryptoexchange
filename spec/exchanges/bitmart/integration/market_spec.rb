require 'spec_helper'

RSpec.describe 'Bitmart integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_jpy_pair) { Cryptoexchange::Models::MarketPair.new(base: 'ABT', target: 'BTC', market: 'bitmart') }

  it 'fetch pairs' do
    pairs = client.pairs('bitmart')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to eq 'ABT'
    expect(pair.target).to eq 'BTC'
    expect(pair.market).to eq 'bitmart'
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_jpy_pair)

    expect(ticker.base).to eq 'ABT'
    expect(ticker.target).to eq 'BTC'
    expect(ticker.market).to eq 'bitmart'
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end
end
