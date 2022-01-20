module Yodlee
  module V1
    class Auth < Yodlee::BaseProduct
      def get_access_token(login_name, &callback)
        cached = cached_response(login_name)

        return cached if cached

        generate_access_token(login_name, &callback)
      end

      private

      def generate_access_token(login_name, &callback)
        headers = AUTH_BASE_HEADERS.merge({ 'loginName' => login_name })
        body = { clientId: configuration.client_id, secret: configuration.client_secret }
        form_data = URI.encode_www_form(body)
        response = http_client.post('auth/token', body: form_data, headers: headers, callback: callback)

        token_expiration = response.dig('token', 'expiresIn')

        cache_response(login_name, response, token_expiration) if token_expiration

        response
      end
    end
  end
end
