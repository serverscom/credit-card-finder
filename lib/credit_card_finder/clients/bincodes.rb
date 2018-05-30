# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module CreditCardFinder
  module Clients
    class Bincodes
      SUCCESS_STATUS_CODE = '200'
      BIN_RANGE = 0..5

      attr_reader :data, :errors

      def initialize
        @errors = {}
      end

      def fetch(code)
        response = nil
        uri = uri(code.to_s[BIN_RANGE])

        Net::HTTP.start(
          uri.host,
          uri.port,
          read_timeout: timeout,
          use_ssl: true
        ) do |http|
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

      def handle_response(response)
        if response.code != SUCCESS_STATUS_CODE
          @errors[:code] = response.code
          @errors[:message] = "Unexpected error from #{endpoint_host}"
          logger.error("BincodesError: #{endpoint_host}. #{response.code}, #{response.body}")
          return self
        end

        body = JSON.parse(response.body)

        if body.has_key?('error')
          @errors[:code] = body['error']
          @errors[:message] = body['message']
          logger.error("BincodesError: [#{errors[:code]}] #{errors[:message]}")
          return self
        end

        logger.info("Fetch credit card data bin #{body['bin']} from #{endpoint_host}")
        @data = body
        self
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
