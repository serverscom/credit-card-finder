# frozen_string_literal: true

require 'logger'
require 'dry-configurable'

module CreditCardFinder
  class Config
    extend Dry::Configurable

    setting :bincodes do
      setting :api_key, '11111111111111'
      setting :api_url, 'https://api.bincodes.com'
      setting :timeout, 10
    end

    setting :strategies, %w[CreditCardBinsStrategy BincodesStrategy]

    setting :logger, Logger.new(STDOUT)
  end
end
