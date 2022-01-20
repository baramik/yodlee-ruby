module Yodlee
  module V1
    class Transactions < Yodlee::BaseProduct
      def get_all(from_date: '2013-01-01', auth_token:, params: {}, txn_per_page: 500, &callback)
        transactions_count_response = get_count(from_date: from_date, auth_token: auth_token)
        transactions_count = transactions_count_response.dig("transaction", "TOTAL", "count")

        return if transactions_count.nil? || transactions_count.zero?

        pages_count = transactions_count.fdiv(txn_per_page).ceil + 1

        fetched_transactions = Concurrent::Array.new
        thread_pool = Concurrent::FixedThreadPool.new(YODLEE_TRANS_FETCH_POOL_SIZE)
        promises = []

        pages_count.times do |page|
          skip = page * txn_per_page
          query_params = params.merge(fromDate: from_date, skip: skip, top: txn_per_page )

          promises << Concurrent::Promises.future_on(thread_pool) do
            response_body = http_client.get("transactions", body: query_params, auth_token: auth_token, callback: callback)

            if response_body['transaction']
              fetched_transactions.concat([response_body['transaction'].reject(&:nil?)])
            end
          end
        end

        Concurrent::Promises.zip(*promises).value!
        thread_pool.shutdown

        { "transaction" => fetched_transactions.flatten! }
      end

      def get_count(from_date:, auth_token:, &callback)
        relative_path = "transactions/count?fromDate=#{from_date}"

        http_client.get(relative_path, auth_token: auth_token, callback: callback)
      end
    end
  end
end
