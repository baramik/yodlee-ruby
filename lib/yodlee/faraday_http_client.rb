module Yodlee
  class FaradayHttpClient
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'Api-Version' => '1.1'
    }.freeze

    def initialize(base_url:)
      @http_client = Faraday.new(url: base_url)
    end

    def get(endpoint, body: nil, headers: nil, auth_token: nil)
      send_request(type: :get, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token)
    end

    def post(endpoint, body: nil, headers: nil, auth_token: nil)
      send_request(type: :post, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token)
    end

    def delete(endpoint, body: nil, headers: nil, auth_token: nil)
      send_request(type: :delete, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token)
    end

    private

    attr_reader :http_client

    def send_request(type:, endpoint:, params: nil, headers: nil, auth_token: nil)
      headers = headers.nil? ? DEFAULT_HEADERS : headers
      headers = headers.merge('Authorization' => "Bearer #{auth_token}") if auth_token

      response = http_client.send(type, endpoint, params, headers)

      parse_response_body(response.body) unless response.status == 204
    end

    def parse_response_body(response_body)
      JSON.parse(response_body)
    rescue JSON::ParserError
      raise "There is no JSON structure in the response"
    end
  end
end