require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class AccountMyTeam < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'account/myTeam'
      end

      def search(params = { skip: 0, limit: 10 })
        prepare_request('post', 'account/searchMyTeam', params: params)
      end

      def get(user_id)
        prepare_request('get', "#{@resource}/#{user_id}")
      end

      def create(params)
        prepare_request('post', @resource, params: params)
      end

      def get_with_external_id(external_id)
        prepare_request('get', @resource, params: { externalId: external_id })
      end

      def delete(user_id)
        prepare_request(:delete, "#{@resource}/#{user_id}")
      end
    end
  end
end
