# frozen_string_literal: true

require 'credit_card_finder/clients/bincodes'
require 'credit_card_finder/strategies/base_strategy'
require 'credit_card_finder/strategies/credit_card_bins_strategy'
require 'credit_card_finder/strategies/bincodes_strategy'
require 'credit_card_finder/proxy'
require 'credit_card_finder/config'
require 'credit_card_finder/version'

module CreditCardFinder
  def self.config
    @config ||= Config.config
  end

  def self.lookup(code)
    Proxy.new.lookup(code)
  end

  def self.logger
    @logger ||= config.logger
  end
end
