require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Document < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'document'
      end

      def delete(document_ids = [])
        prepare_request(:delete, @resource, params: { documentIds: document_ids })
      end
    end
  end
end
