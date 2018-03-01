require 'smartcat_sdk'

ACCOUNT_ID = 'ACCOUNT_ID'.freeze
API_KEY = 'API_KEY'.freeze

# Project API end-point
# -------------------------------------------------------------
project = SmartcatSDK::REST::Project.new(ACCOUNT_ID, API_KEY)
# Get project details
puts project.get('EXAMPLE_PROJECT_ID')
