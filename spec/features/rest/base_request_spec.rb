require 'smartcat_sdk/rest/base_request'

RSpec.describe SmartcatSDK::REST::BaseRequest do
  context '#errors' do
    it 'valid arguments' do
      expect(described_class.new('account_id', 'api_key').is_a?(described_class)).to eq(true)
    end
  end

  context '#errors' do
    it 'mission api key error' do
      expect do
        described_class.new
      end.to raise_error(ArgumentError, 'Account ID is required')
    end

    it 'mission account id error' do
      expect do
        described_class.new('account_id')
      end.to raise_error(ArgumentError, 'API key is required')
    end
  end
end
