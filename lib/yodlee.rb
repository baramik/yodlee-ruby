# frozen_string_literal: true
require 'logger'
require 'uri'
require "json"
require "faraday"
require "redis"
require "concurrent-ruby"
require "active_support"
require "active_support/core_ext"

require_relative "yodlee/version"
require_relative 'yodlee/faraday_http_client'
require_relative "yodlee/products/base_product"
require_relative "yodlee/products/v1/accounts"
require_relative "yodlee/products/v1/auth"
require_relative "yodlee/products/v1/providers"
require_relative "yodlee/products/v1/transactions"
require_relative "yodlee/products/v1/users"
require_relative "yodlee/products/v1/provider_accounts"

require_relative "yodlee/configuration"
require_relative "yodlee/api_client"

module Yodlee
  class Error < StandardError; end
end
