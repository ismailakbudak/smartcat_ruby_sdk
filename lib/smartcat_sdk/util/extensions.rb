require 'yaml'

module SmartcatSDK
  module Util
    module Extensions
      def self.list
        config_file = File.dirname(__FILE__) + '/smartcat_ai.yml'
        YAML.load_file(config_file)['types']
      end
    end
  end
end
