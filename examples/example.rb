require 'smartcat_sdk'

ACCOUNT_ID = 'ACCOUNT_ID'.freeze
API_KEY = 'API_KEY'.freeze

# Project API end-point
# -------------------------------------------------------------
project = SmartcatSDK::REST::Project.new(ACCOUNT_ID, API_KEY)
# Get project details
PROJECT_ID = 'EXAMPLE_PROJECT_ID'.freeze
puts project.get(PROJECT_ID)

# Create project without file
model = {
  'name' => 'Test',
  'description' => 'Test',
  'sourceLanguage' => 'tr',
  'targetLanguages' => %w[en],
  'workflowStages' => [
    'translation'
  ],
  'assignToVendor' => false
}
puts project.create(model)
# Create project with files
puts project.create(model, files: %w[files/Test.txt files/Test-2.txt])
