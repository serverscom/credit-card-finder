# frozen_string_literal: true

module CreditCardFinder
  class Proxy
    attr_reader :strategies

    def initialize
      @strategies ||= resolve_strategies
    end

    def lookup(code)
      run_strategies(code)
    end

    private

    def run_strategies(code)
      strategies.each do |strategy|
        strategy_class = search_strategy(strategy)
        next if strategy_class.nil?
        result = strategy_class.new.lookup(code)
        return result if result
      end
      nil
    end

    def resolve_strategies
      CreditCardFinder.config.strategies || default_strategies
    end

    def default_strategies
      %w[CreditCardBinsStrategy BincodesStrategy]
    end

    def search_strategy(strategy)
      Object.const_get("CreditCardFinder::Strategies::#{strategy}")
    rescue NameError
      nil
    end
  end
end
