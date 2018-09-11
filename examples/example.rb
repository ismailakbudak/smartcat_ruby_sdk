require 'smartcat_sdk'

ACCOUNT_ID = 'ACCOUNT_ID'.freeze
API_KEY = 'API_KEY'.freeze

# -------------------------------------------------------------
# -------------------------------------------------------------
# Account API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
account = SmartcatSDK::REST::Account.new(ACCOUNT_ID, API_KEY)
# Get account
puts account.detail
# Get account MT engines
puts account.mtengines

# -------------------------------------------------------------
# -------------------------------------------------------------
# AccountMyTeam API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
team = SmartcatSDK::REST::AccountMyTeam.new(ACCOUNT_ID, API_KEY)
# Search team users
puts team.search
# Create team user
params = {
  email: 'test@gmail.com',
  firstName: 'Test',
  lastName: 'Test',
  externalId: '123',
  services: [
    {
      serviceType: 'translation',
      sourceLanguage: 'tr',
      targetLanguage: 'en',
      pricePerUnit: 1,
      currency: 'usd',
      specializations: [
        'education'
      ]
    }
  ]
}
user = team.create(params)
puts user.inspect
# Get team user with id
puts team.get(user['id'])
# Get team user with external id
puts team.get_with_external_id('123')
# Delete user
puts team.delete(user['id'])

# -------------------------------------------------------------
# -------------------------------------------------------------
# Client API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
client = SmartcatSDK::REST::Client.new(ACCOUNT_ID, API_KEY)
CLIENT_ID = 'EXAMPLE_CLIENT_ID'.freeze
CLIENT_NET_RATE_ID = 'EXAMPLE_CLIENT_NET_RATE_ID'.freeze
# Create client
name = 'John Foe'
puts client.create(name)
# Get client
puts client.get(CLIENT_ID)
# Update client -- TODO: does not work now or does not update name field
params = {
  name: 'John Foo'
}
puts client.update(CLIENT_ID, CLIENT_NET_RATE_ID, params)

# -------------------------------------------------------------
# -------------------------------------------------------------
# TranslationMemory API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
translation_memory = SmartcatSDK::REST::TranslationMemory.new(ACCOUNT_ID, API_KEY)
TRANSLATION_MEMORY_ID = 'EXAMPLE_CLIENT_ID'.freeze
# Get translation memories
filters = {
  batchSize: 1,
  sourceLanguage: 'tr',
  targetLanguage: 'de',
  clientId: CLIENT_ID,
  searchName: 'Second'
}
puts translation_memory.all(filters)
# Get translation memory with id
puts translation_memory.get(TRANSLATION_MEMORY_ID)
# Create translation memory
params = {
  name: 'Test Second',
  sourceLanguage: 'tr',
  targetLanguages: %w[de en is],
  description: 'Test',
  clientId: CLIENT_ID
}
puts translation_memory.create(params)

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

# Post update translation memories of project
translation_memory_models = [
  {
    id: TRANSLATION_MEMORY_ID,
    matchThreshold: 50,
    isWritable: true
  }
]
puts project.update_translation_memories(PROJECT_ID, translation_memory_models)

# -------------------------------------------------------------
# -------------------------------------------------------------
# Document API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
document = SmartcatSDK::REST::Document.new(ACCOUNT_ID, API_KEY)
# Assign document to team member
params = {
  executives: [
    {
      id: 'your_account_team_user_id',
      wordsCount: 0
    }
  ],
  minWordsCountForExecutive: 0,
  assignmentMode: 'distributeAmongAll'
}
puts document.assign(params, '2048153_9')
# Assign from team
params = {
  documentIds: [
    '2048153_9'
  ],
  stageNumber: 1
}
puts document.assign_from_my_team(params)
# Get document
puts document.get('2048153_9')
# Get cross auth url
puts document.get_auth_url('your_account_team_user_id', '2048153_9')
# Delete documents
DOCUMENT_IDS = %w[2048153_9 2048153_7].freeze
puts document.delete(DOCUMENT_IDS)

# -------------------------------------------------------------
# -------------------------------------------------------------
# DocumentExport API end-point
# -------------------------------------------------------------
# -------------------------------------------------------------
document_export = SmartcatSDK::REST::DocumentExport.new(ACCOUNT_ID, API_KEY)
# Create document export task
params = {
  documentIds: %w[
    2883908_7
    2883907_7
  ],
  type: 'target',
  stageNumber: 1
}

document_export_task = document_export.create(params)
# Get document export task
puts document_export.get(document_export_task['id'])
