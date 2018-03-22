require 'smartcat_sdk'

ACCOUNT_ID = 'ACCOUNT_ID'.freeze
API_KEY = 'API_KEY'.freeze

# -------------------------------------------------------------
# -------------------------------------------------------------
# Project API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
project = SmartcatSDK::REST::Project.new(ACCOUNT_ID, API_KEY)
# Get project details
PROJECT_ID = 'EXAMPLE_PROJECT_ID'.freeze
puts project.get(PROJECT_ID)

# Update project
model = {
  'name' => 'Updated name',
  'description' => 'Updated description',
  'externalTag' => 'id'
}
puts project.update(PROJECT_ID, model)

# Delete project
puts project.delete(PROJECT_ID)

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

# Get project statistics
puts project.statistics(PROJECT_ID)

# Get project statistics v2
puts project.statistics_v2(PROJECT_ID)

# Post project statistics build
puts project.statistics_build(PROJECT_ID)

# Post add target language to project
puts project.add_language(PROJECT_ID, 'de')
puts project.add_language(PROJECT_ID, 'it')

# Post add document to project
puts project.add_document(
  PROJECT_ID,
  files_model: [{ externalId: 'test1' }, { externalId: 'test2' }],
  files: %w[files/Test.txt files/Test-2.txt]
)

# Post project cancel
puts project.cancel(PROJECT_ID)

# Post project restore
puts project.restore(PROJECT_ID)

# Post project complete
puts project.complete(PROJECT_ID)

# -------------------------------------------------------------
# -------------------------------------------------------------
# Document API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
document = SmartcatSDK::REST::Document.new(ACCOUNT_ID, API_KEY)
# Delete documents
DOCUMENT_IDS = %w[2048153_9 2048153_7].freeze
puts document.delete(DOCUMENT_IDS)
