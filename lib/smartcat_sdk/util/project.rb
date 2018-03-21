module SmartcatSDK
  module Util
    module Project
      MODEL_KEY = 'model'.freeze

      class << self
        def params(project_model, files)
          params = {
            SmartcatSDK::Util::Project::MODEL_KEY => JSON.generate(project_model)
          }
          prepare_files(files, params)
          params
        end

        def model_headers
          {
            parts: {
              MODEL_KEY => {
                'Content-Type' => 'application/json'
              }
            }
          }
        end

        private

        # :reek:TooManyStatements { enabled: false }
        def prepare_files(files, params)
          index = 0
          files.each do |path|
            file_name = File.basename(path)
            file = File.new(path)
            content_type = MIME::Types.type_for(file.path).first.to_s
            params["project_file#{index}"] = UploadIO.new(file, content_type, file_name)
            index += 1
          end
        end
      end
    end
  end
end
