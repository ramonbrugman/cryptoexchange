require 'spec_helper'

RSpec.describe 'GateFutures integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:eth_usd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'ETH', target: 'USD', inst_id: "ETH_USD", market: 'gate_futures', contract_interval: "perpetual") }

  it 'fetch pairs' do
    pairs = client.pairs('gate_futures')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.inst_id).to_not be nil
    expect(pair.market).to eq 'gate_futures'
    expect(pair.contract_interval).to eq "perpetual"
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url "gate_futures", inst_id: eth_usd_pair.inst_id
    expect(trade_page_url).to eq "https://www.gate.io/futures_trade/ETH_USD"
  end

  it 'fetch ticker' do
    ticker = client.ticker(eth_usd_pair)

    expect(ticker.base).to eq 'ETH'
    expect(ticker.target).to eq 'USD'
    expect(ticker.market).to eq 'gate_futures'
    expect(ticker.inst_id).to eq 'ETH_USD'
    expect(ticker.last).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
    expect(ticker.contract_interval).to eq "perpetual"
  end

  it 'fetch order book' do
    order_book = client.order_book(eth_usd_pair)

    expect(order_book.base).to eq 'ETH'
    expect(order_book.target).to eq 'USD'
    expect(order_book.market).to eq 'gate_futures'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(eth_usd_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'ETH'
    expect(trade.target).to eq 'USD'
    expect(trade.market).to eq 'gate_futures'
    expect(trade.trade_id).to_not be_nil
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
  end

  context 'fetch contract stat' do
    it 'fetch contract stat and contract details' do
      contract_stat = client.contract_stat(eth_usd_pair)

      expect(contract_stat.base).to eq 'ETH'
      expect(contract_stat.target).to eq 'USD'
      expect(contract_stat.market).to eq 'gate_futures'
      expect(contract_stat.index).to be_a Numeric
      expect(contract_stat.index_identifier).to eq "GateFutures-ETH_USD"
      expect(contract_stat.index_name).to eq "Gate.io ETH/USD"
      expect(contract_stat.open_interest).to be_a Numeric
      expect(contract_stat.timestamp).to be nil

      expect(contract_stat.expire_timestamp).to be nil
      expect(contract_stat.start_timestamp).to be nil
      expect(contract_stat.contract_type).to eq 'perpetual'
      expect(contract_stat.funding_rate_percentage).to be_a Numeric
      expect(2018..Date.today.year).to include(Time.at(contract_stat.next_funding_rate_timestamp).year)
      expect(contract_stat.funding_rate_percentage_predicted).to be_a Numeric


      expect(contract_stat.payload).to_not be nil
    end
  end
end
