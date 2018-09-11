require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class DocumentExport < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'document/export'
      end

      def get(task_id)
        prepare_request('get', "#{@resource}/#{task_id}", format: :response)
      end

      def create(query_params)
        query = URI.encode_www_form(query_params)
        prepare_request('post', "#{@resource}?#{query}")
      end
    end
  end
end
