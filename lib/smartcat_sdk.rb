require 'net/http'
require 'net/https'
require 'json'

# Our multipart post lib
require 'net/http/post/multipart'

# JSON parser
require 'multi_json'

# File format decider
require 'mime/types'

# Smartcat files
require 'smartcat_sdk/version' unless defined?(SmartcatSDK::VERSION)
require 'smartcat_sdk/util/client_config'
require 'smartcat_sdk/util/project'
require 'smartcat_sdk/util/request'
require 'smartcat_sdk/rest/errors'
require 'smartcat_sdk/rest/project'

module SmartcatSDK
  # Your code goes here...
end
