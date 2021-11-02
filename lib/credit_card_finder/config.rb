# frozen_string_literal: true

require 'logger'
require 'dry-configurable'

module CreditCardFinder
  class Config
    extend Dry::Configurable

    setting :bincodes do
      setting :api_key, default: '11111111111111'
      setting :api_url, default: 'https://api.bincodes.com'
      setting :timeout, default: 10
    end

    setting :strategies, default: %w[CreditCardBinsStrategy BincodesStrategy]

    setting :logger, default: Logger.new(STDOUT)
  end
end
