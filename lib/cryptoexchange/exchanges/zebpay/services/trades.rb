module Cryptoexchange::Exchanges
  module Zebpay
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Zebpay::Market::API_URL}/trades?market=#{market_pair.base.downcase}_#{market_pair.target.downcase}"
        end

        def adapt(output, market_pair)
          output.collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade["tid"]
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.market    = Zebpay::Market::NAME
            tr.type      = trade["type"]
            tr.price     = trade["price"]
            tr.amount    = trade["amount"]
            tr.timestamp = trade["date"].to_i
            tr.payload   = trade
            tr
          end
        end
      end
    end
  end
end
