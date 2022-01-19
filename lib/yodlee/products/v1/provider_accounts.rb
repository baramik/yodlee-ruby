module Yodlee
  module V1
    class ProviderAccounts < Yodlee::BaseProduct
      def get(provider_account_id, auth_token:, &callback)
        raise 'provider account id could not be nil' unless provider_account_id

        http_client.get('providerAccounts/' << provider_account_id.to_s, auth_token: auth_token, callback: callback)
      end

      def get_all(auth_token:, &callback)
        http_client.get('accounts?include=fullAccountNumber', auth_token: auth_token, callback: callback)
      end
    end
  end
end
