module Yodlee
  class FaradayHttpClient
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'Api-Version' => '1.1'
    }.freeze

    def initialize(base_url:)
      @http_client = Faraday.new(url: base_url)
    end

    def get(endpoint, body: nil, headers: nil, auth_token: nil, callback: nil)
      send_request(type: :get, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token, callback: callback)
    end

    def post(endpoint, body: nil, headers: nil, auth_token: nil, callback: nil)
      send_request(type: :post, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token, callback: callback)
    end

    def delete(endpoint, body: nil, headers: nil, auth_token: nil, callback: nil)
      send_request(type: :delete, endpoint: endpoint, params: body, headers: headers, auth_token: auth_token, callback: callback)
    end

    private

    attr_reader :http_client

    # @param callback [Proc] Optional. Block that will be executed after HTTP request is done
    def send_request(type:, endpoint:, params: nil, headers: nil, auth_token: nil, callback: nil)
      headers = headers.nil? ? DEFAULT_HEADERS : headers
      headers = headers.merge('Authorization' => "Bearer #{auth_token}") if auth_token

      response = http_client.send(type, endpoint, params, headers)
      make_callback(response, callback) if callback

      parse_response_body(response.body) unless response.status == 204
    end

    def make_callback(response, callback)
      request_data = {
        url: response.env.url.to_s,
        method: response.env.method,
        headers: response.env.request_headers,
        body: response.env.request_body
      }
      response_data = { headers: response.headers, body: response.body, status: response.status }
      callback.call(request_data, response_data)
    end

    def parse_response_body(response_body)
      JSON.parse(response_body)
    rescue JSON::ParserError
      raise "There is no JSON structure in the response"
    end
  end
end
