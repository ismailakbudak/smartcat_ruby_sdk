module SmartcatSDK
  module Util
    module Request
      RUBY_INFO = "(#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL})".freeze
      HTTP_HEADERS = {
        'Accept'          => 'application/json',
        'Accept-Charset'  => 'utf-8',
        'User-Agent'      => "smartcat_sdk/#{SmartcatSDK::VERSION} #{RUBY_INFO}"
      }.freeze

      class << self
        def prepare(headers, method, params, uri)
          if method == :post_multipart
            return Net::HTTP::Post::Multipart.new(uri, params, HTTP_HEADERS.merge(headers))
          end
          method_class = Net::HTTP.const_get method.to_s.capitalize
          request = method_class.new(uri.to_s, headers)
          request.form_data = params if %w[post put].include?(method)
          request
        end
      end
    end
  end
end
