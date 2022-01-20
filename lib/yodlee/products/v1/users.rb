module Yodlee
  module V1
    class Users < Yodlee::BaseProduct
      def register(login_name, &callback)
        admin_access_token = Yodlee::V1::Auth
                               .new(http_client: http_client, configuration: configuration)
                               .get_access_token(configuration.admin_login, &callback)

        body = { user: { loginName: login_name } }.to_json

        http_client.post('user/register', body: body, auth_token: admin_access_token.dig('token', 'accessToken'), callback: callback)
      end

      def get(login_name, &callback)
        access_token = Yodlee::V1::Auth
                         .new(http_client: http_client, configuration: configuration)
                         .get_access_token(login_name, &callback)

        http_client.get('user', auth_token: access_token.dig('token', 'accessToken'), callback: callback)
      end

      def delete(login_name, &callback)
        access_token = Yodlee::V1::Auth
                         .new(http_client: http_client, configuration: configuration)
                         .get_access_token(login_name, &callback)

        http_client.delete('user/unregister', auth_token: access_token.dig('token', 'accessToken'), callback: callback)
      end
    end
  end
end
