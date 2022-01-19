# frozen_string_literal: true

RSpec.describe Yodlee::ApiClient do
  describe '#users' do
    it 'execute callback function' do
      callback = lambda { |req, resp| puts 'Hello World' }
      expect(callback).to receive(:call).twice

      described_class.users.get('123', &callback)
    end
  end
end
