module Yodlee
  module V1
    class Providers < Yodlee::BaseProduct
      def all(auth_token:)
        http_client.get('providers', auth_token: auth_token)
      end

      def by_id(id, auth_token:)
        raise 'provider Id could not be nil' unless id

        http_client.get('providers/' << id.to_s, auth_token: auth_token)
      end

      def by_routing_number(routing_number, auth_token:)
        http_client.get("providers", body: { name: routing_number }, auth_token: auth_token)
      end
    end
  end
end