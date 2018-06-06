# frozen_string_literal: true

require 'credit_card_bins'

module CreditCardFinder
  module Strategies
    class CreditCardBinsStrategy < BaseStrategy
      CARD_INFO_MATCHING = {
        'bin' => 'bin',
        'bank' => 'issuer',
        'card' => 'brand',
        'type' => 'type',
        'level' => 'category'
      }.freeze

      def lookup(number)
        @card_data = CreditCardBin.new(number).data
        return if @card_data.nil?

        self
      rescue NotFound
        nil
      end

      (CARD_INFO_METHODS - %w[country countrycode]).each do |m|
        define_method(m) do
          @card_data.fetch(CARD_INFO_MATCHING[m], nil)
        end
      end

      def country
        @card_data.fetch('country', {})['name']
      end

      def countrycode
        @card_data.fetch('country', {})['alpha_2']
      end
    end
  end
end
