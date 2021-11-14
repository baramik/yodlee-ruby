module Yodlee
  module V1
    class ProviderAccounts < Yodlee::BaseProduct
      def get(provider_account_id, auth_token:)
        raise 'provider account id could not be nil' unless provider_account_id

        http_client.get('providerAccounts/' << provider_account_id.to_s, auth_token: auth_token)
      end

      def get_all(auth_token:)
        http_client.get('accounts?include=fullAccountNumber', auth_token: auth_token)
      end
    end
  end
end
