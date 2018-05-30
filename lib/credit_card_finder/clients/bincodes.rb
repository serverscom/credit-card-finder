# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module CreditCardFinder
  module Clients
    class Bincodes
      BIN_RANGE = 0..5

      attr_reader :data, :errors

      def initialize
        @errors = {}
      end

      def fetch(code)
        response = nil
        uri = uri(code.to_s[BIN_RANGE])

        Net::HTTP.start(uri.host, uri.port, read_timeout: timeout, use_ssl: true) do |http|
          request = Net::HTTP::Get.new(uri)
          response = http.request(request)
        end

        handle_response(response)
      end

      def valid?
        @errors.empty?
      end

      def invalid?
        !valid?
      end

      private

      def logger
        CreditCardFinder.logger
      end

      # rubocop:disable Metrics/MethodLength
      def handle_response(response)
        unless response.is_a?(Net::HTTPSuccess)
          halt_unexpected_error(response)
          return self
        end

        body = JSON.parse(response.body)
        if body.key?('error')
          halt_service_error(body)
          return self
        end

        @data = body
        logger.info("Fetch credit card data bin #{body['bin']} from #{endpoint_host}")
        self
      end
      # rubocop:enable Metrics/MethodLength

      def halt_service_error(body)
        @errors[:code] = body['error']
        @errors[:message] = body['message']
        logger.error("BincodesError: [#{errors[:code]}] #{errors[:message]}")
      end

      def halt_unexpected_error(response)
        @errors[:code] = response.code
        @errors[:message] = "Unexpected error from #{endpoint_host}"
        logger.error("BincodesError: #{endpoint_host}. #{response.code}, #{response.body}")
      end

      def timeout
        CreditCardFinder.config.bincodes.timeout || 10
      end

      def endpoint_host
        CreditCardFinder.config.bincodes.api_url
      end

      def api_key
        CreditCardFinder.config.bincodes.api_key
      end

      def uri(code)
        URI("#{endpoint_host}/bin/json/#{api_key}/#{code}/")
      end
    end
  end
end
