module SmartcatSDK
  module REST
    class BaseRequest
      RUBY_INFO = "(#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL})".freeze
      HTTP_HEADERS = {
        'Accept'          => 'application/json',
        'Accept-Charset'  => 'utf-8',
        'User-Agent'      => "smartcat_sdk/#{SmartcatSDK::VERSION} #{RUBY_INFO}"
      }.freeze

      def initialize(*args)
        options     = args.last.is_a?(Hash) ? args.pop : {}
        @config     = SmartcatSDK::Util::ClientConfig.new options
        @user       = args[0] || nil
        @password   = args[1] || nil
        raise ArgumentError, 'Account ID is required' if @user.nil?
        raise ArgumentError, 'API key is required' if @password.nil?
        set_up_connection
      end

      protected

      ##
      # Prepare http request
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def prepare_request(method, path, params: {})
        request_path = @config.host
        request_path += "/api/integration/v1/#{path}"
        uri = URI.parse(request_path)
        uri.query = URI.encode_www_form(params) if %w[get delete].include?(method)
        method_class = Net::HTTP.const_get method.to_s.capitalize
        request = method_class.new(uri.to_s, HTTP_HEADERS)
        request.form_data = params if %w[post put].include?(method)
        request.basic_auth(@user, @password)
        connect_and_send(request)
      end

      private

      ##
      # Set up and cache a Net::HTTP object to use when making requests.
      def set_up_connection
        uri = URI.parse(@config.host)
        @http = Net::HTTP.new(
          uri.host,
          uri.port,
          @config.proxy_addr,
          @config.proxy_port,
          @config.proxy_user,
          @config.proxy_pass
        )
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @http.use_ssl = @config.use_ssl
        if @config.ssl_verify_peer
          @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          @http.ca_file = @config.ssl_ca_file
        else
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        @http.open_timeout = @config.timeout
        @http.read_timeout = @config.timeout
      end

      ##
      # Send an HTTP request using the cached <tt>@http</tt> object and
      # return the JSON response body parsed into a hash. Also save the raw
      # Net::HTTP::Request and Net::HTTP::Response objects as
      # <tt>@last_request</tt> and <tt>@last_response</tt> to allow for
      # inspection later.
      def connect_and_send(request, is_file = false)
        @last_request = request
        retries_left = @config.retry_limit
        begin
          response = @http.request request
          @last_response = response
          raise SmartcatSDK::REST::ServerError if response.is_a?(Net::HTTPServerError)
        rescue StandardError => _error
          raise if request.class == Net::HTTP::Post
          raise if retries_left <= 0
          retries_left -= 1
          retry
        end
        handle_response_errors(handle_response(is_file, response), response)
      end

      def handle_response_errors(object, response)
        return object unless response.is_a?(Net::HTTPClientError)
        raise SmartcatSDK::REST::RequestError.new(object['error'], object['code'])
      end

      def handle_response(is_file, response)
        if response.body && !response.body.empty?
          return response.body if is_file
          MultiJson.load(response.body)
        elsif response.is_a?(Net::HTTPBadRequest)
          {
            message: 'Bad request',
            code: 400
          }
        end
      end
    end
  end
end
