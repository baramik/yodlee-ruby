module Yodlee
  class Configuration
    attr_reader :redis_endpoint,
                :logger,
                :client_secret,
                :api_endpoint,
                :admin_login,
                :client_id,
                :cache,
                :api_version,
                :redis_instance

    def initialize
      @logger = find_logger(logger)
      @cache = false
      @api_version = :v1
      @api_endpoint = "https://development.api.yodlee.com/ysl"
      @redis_endpoint = "redis://localhost:6379"
      @redis_instance = init_redis
    end

    def redis_endpoint=(endpoint)
      raise ArgumentError, "Redis endpoint should be set" if cache && endpoint.nil?

      @redis_endpoint = endpoint
    end

    def api_endpoint=(api_endpoint)
      raise ArgumentError unless api_endpoint

      @api_endpoint = api_endpoint
    end

    def client_id=(client_id)
      raise ArgumentError unless client_id

      @client_id = client_id
    end

    def admin_login=(admin_login)
      raise ArgumentError unless admin_login

      @admin_login = admin_login
    end

    def client_secret=(client_secret)
      raise ArgumentError unless client_secret

      @client_secret = client_secret
    end

    def cache=(value)
      raise ArgumentError unless api_endpoint

      @cache = value
    end

    private

    def init_redis
      Redis.current ||= Redis.new(url: redis_endpoint) if cache
    end

    def find_logger(logger)
      return logger if logger
      return Rails.logger if defined?(Rails)

      logger = Logger.new($stderr)
      logger.level = Logger::DEBUG
      logger
    end
  end
end