# frozen_string_literal: true
# Class for global gem configuration
#

module Yodlee
  class ApiClient
    class << self
      AVAILABLE_PRODUCTS = {
        v1: %i[accounts providers auth users transactions provider_accounts]
      }.freeze

      def http_client
        @http_client ||= Yodlee::FaradayHttpClient.new(base_url: config.api_endpoint)
      end

      def config
        @config ||= Configuration.new
      end

      def configure
        raise unless block_given?

        yield(config)
      end

      def method_missing(method, *args, &block)
        current_config_version = config.api_version.downcase.to_sym

        if AVAILABLE_PRODUCTS[current_config_version].include?(method)
          Object
            .const_get("Yodlee::#{current_config_version.capitalize}::#{method.to_s.camelize}")
            .new(http_client: http_client, configuration: config)
        else
          super
        end
      end

      def respond_to_missing?
      end
    end
  end
end
