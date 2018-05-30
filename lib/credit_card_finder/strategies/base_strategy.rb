# frozen_string_literal: true

module CreditCardFinder
  module Strategies
    class BaseStrategy
      CARD_INFO_METHODS = %w[
        bin
        bank
        card
        type
        level
        country
        countrycode
      ].freeze

      CARD_INFO_METHODS.each do |m|
        define_method(m) do
          raise NotImplementedError
        end
      end

      def lookup(_code)
        raise NotImplementedError
      end
    end
  end
end
