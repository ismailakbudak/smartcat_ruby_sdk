require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Document < BaseRequest
      def initialize(*args)
        super(*args)
        @resource = 'document'
      end

      def get(document_id)
        prepare_request('get', @resource, params: { documentId: document_id })
      end

      def assign(request_model, document_id, stage_number: 1)
        prepare_request('post',
                        "#{@resource}/assign?documentId=#{document_id}&stageNumber=#{stage_number}",
                        params: request_model)
      end

      def assign_from_my_team(params)
        prepare_request('post', "#{@resource}/assignFromMyTeam", params: params)
      end

      def get_auth_url(user_id, document_id)
        params = { userId: user_id, documentId: document_id }
        prepare_request('get', "#{@resource}/getAuthUrl", params: params)
      end

      def delete(document_ids = [])
        prepare_request(:delete, @resource, params: { documentIds: document_ids })
      end
    end
  end
end
