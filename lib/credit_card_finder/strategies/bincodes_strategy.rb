# frozen_string_literal: true

module CreditCardFinder
  module Strategies
    class BincodesStrategy < BaseStrategy
      def lookup(code)
        res = CreditCardFinder::Clients::Bincodes.new.fetch(code)
        return if res.invalid?

        @card_data = res.data
        self
      end

      CARD_INFO_METHODS.each do |m|
        define_method(m) do
          @card_data.fetch(m, nil)
        end
      end
    end
  end
end
