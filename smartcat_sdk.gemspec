
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartcat_sdk/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'smartcat_sdk'
  spec.version       = SmartcatSDK::VERSION
  spec.authors       = ['Ismail Akbudak']
  spec.email         = ['ismail.akbudak@lab2023.com']
  spec.summary       = 'SmartCat Ruby SDK.'
  spec.description   = 'SmartCat API SDK for ruby & ruby on rails.'
  spec.homepage      = 'https://github.com/ismailakbudak/smartcat_ruby_sdk'
  spec.license       = 'MIT'
  spec.date          = Date.today.strftime('%Y-%m-%d')
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'multi_json', '~> 1.13', '>= 1.13.1'
  spec.add_runtime_dependency 'multipart-post', '~> 2.0'
  spec.add_dependency 'mime-types', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pronto', '~> 0.9.5'
  spec.add_development_dependency 'pronto-fasterer', '~> 0.9.0'
  spec.add_development_dependency 'pronto-flay', '~> 0.9.0'
  spec.add_development_dependency 'pronto-reek', '~> 0.9.0'
  spec.add_development_dependency 'pronto-rubocop', '~> 0.9.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
