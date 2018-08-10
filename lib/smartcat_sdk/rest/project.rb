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

      def update(project_id, project_model)
        prepare_request(
          :put,
          "#{@resource}/#{project_id}",
          params: project_model
        )
      end

      def delete(project_id)
        prepare_request(:delete, "#{@resource}/#{project_id}")
      end

      def statistics(project_id)
        prepare_request(:get, "#{@resource}/#{project_id}/statistics")
      end

      # :reek:UncommunicativeMethodName { enabled: false }
      def statistics_v2(project_id)
        prepare_request(:get, "#{@resource}/#{project_id}/statistics", version: 'v2')
      end

      def statistics_build(project_id)
        prepare_request(:post, "#{@resource}/#{project_id}/statistics/build")
      end

      def add_language(project_id, target_language)
        prepare_request(
          :post,
          "#{@resource}/language?projectId=#{project_id}&targetLanguage=#{target_language}"
        )
      end

      def add_document(project_id, files: [], files_model: [])
        prepare_request(
          :post_multipart,
          "#{@resource}/document?projectId=#{project_id}",
          params: SmartcatSDK::Util::Project.params(files_model, files),
          headers: SmartcatSDK::Util::Project.model_headers
        )
      end

      def update_translation_memories(project_id, translation_memory_models)
        prepare_request(
          :post,
          "#{@resource}/#{project_id}/translationmemories",
          params: translation_memory_models
        )
      end

      def cancel(project_id)
        prepare_request(:post, "#{@resource}/cancel?projectId=#{project_id}")
      end

      def restore(project_id)
        prepare_request(:post, "#{@resource}/restore?projectId=#{project_id}")
      end

      def complete(project_id)
        prepare_request(:post, "#{@resource}/complete?projectId=#{project_id}")
      end
    end
  end
end
