require 'smartcat_sdk/rest/base_request'

module SmartcatSDK
  module REST
    class Project < BaseRequest

      def initialize(*args)
        super(*args)
        @resource = 'project'
      end

      def get(project_id)
        prepare_request(:get, "#{@resource}/#{project_id}")
      end
    end
  end
end
