module Yodlee
  module V1
    class Accounts < Yodlee::BaseProduct
      def get(account_id, auth_token:, &callback)
        raise 'account id could not be nil' unless account_id

        http_client.get('accounts/' << account_id.to_s, auth_token: auth_token, callback: callback)
      end

      def get_all(auth_token:, &callback)
        http_client.get('accounts?include=fullAccountNumber', auth_token: auth_token, callback: callback)
      end
    end
  end
end
