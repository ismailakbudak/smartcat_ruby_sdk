require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Client < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'client'
      end

      def get(id)
        prepare_request('get', "#{@resource}/#{id}")
      end

      def create(params)
        prepare_request('post', "#{@resource}/create", params: params)
      end

      def update(id, net_rate_id, params)
        prepare_request('put', "#{@resource}/#{id}/set?netRateId=#{net_rate_id}", params: params)
      end
    end
  end
end
