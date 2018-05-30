require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class TranslationMemory < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'translationmemory'
      end

      def all(filters = {})
        defaults = { lastProcessedId: nil, batchSize: 100 }
        prepare_request('get', @resource, params: defaults.merge(filters))
      end

      def get(id)
        prepare_request('get', "#{@resource}/#{id}")
      end

      def create(params)
        prepare_request('post', @resource, params: params)
      end
    end
  end
end
