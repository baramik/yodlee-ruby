module Yodlee
  module V1
    class Accounts < Yodlee::BaseProduct
      def get(account_id, auth_token:)
        raise 'account id could not be nil' unless id

        http_client.get('accounts/' << account_id.to_s, auth_token: auth_token)
      end

      def get_all(auth_token:)
        http_client.get('accounts?include=fullAccountNumber', auth_token: auth_token)
      end
    end
  end
end
