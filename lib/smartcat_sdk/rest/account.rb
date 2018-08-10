require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Account < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'account'
      end

      def detail
        prepare_request('get', @resource)
      end

      def mtengines
        prepare_request('get', "#{@resource}/mtengines")
      end
    end
  end
end
