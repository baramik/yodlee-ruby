module Yodlee
  class BaseProduct
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'Api-Version' => '1.1'
    }.freeze

    AUTH_BASE_HEADERS = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Api-Version' => '1.1'
    }.freeze

    YODLEE_TRANS_FETCH_POOL_SIZE = 5

    def initialize(http_client:, configuration:)
      @http_client = http_client
      @configuration = configuration
    end

    private

    attr_reader :http_client, :configuration

    def send_authenticated_request(auth_token:)
      DEFAULT_HEADERS.merge('Authorization' => "Bearer #{auth_token}")
    end

    def cached_response(unique_key)
      redis = configuration.redis_instance

      return unless redis

      val = redis.get(unique_key)

      return unless val

      JSON.parse(val)
    end

    def cache_response(unique_key, value, ttl)
      redis = configuration.redis_instance

      return unless redis
      redis.setex(unique_key, ttl, value.to_json)
    end
  end
end