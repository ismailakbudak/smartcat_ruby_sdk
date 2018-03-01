require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Project < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'project'
      end

      # @param [Hash] project_model
      # @param [Array] files file directory paths
      def create(project_model, files: [])
        prepare_request(
          :post_multipart,
          "#{@resource}/create",
          params: SmartcatSDK::Util::Project.params(project_model, files),
          headers: SmartcatSDK::Util::Project.model_headers
        )
      end

      def get(project_id)
        prepare_request(:get, "#{@resource}/#{project_id}")
      end
    end
  end
end
