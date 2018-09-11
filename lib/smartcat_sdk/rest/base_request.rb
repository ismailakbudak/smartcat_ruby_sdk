module SmartcatSDK
  module REST
    class BaseRequest
      def initialize(*args)
        options     = args.last.is_a?(Hash) ? args.pop : {}
        @config     = SmartcatSDK::Util::ClientConfig.new options
        @user       = args[0] || nil
        @password   = args[1] || nil
        raise ArgumentError, 'Account ID is required' unless @user
        raise ArgumentError, 'API key is required' unless @password
        set_up_connection
      end

      protected

      ##
      # Prepare http request
      # :reek:TooManyStatements { enabled: false }
      # :reek:LongParameterList { enabled: false }
      # rubocop:disable Metrics/ParameterLists
      def prepare_request(method, path, params: {}, headers: {}, version: 'v1', format: :json)
        request_path = @config.host
        request_path += "/api/integration/#{version}/#{path}"
        uri = URI.parse(request_path)
        uri.query = URI.encode_www_form(params) if %w[get delete].include?(method.to_s)
        request = SmartcatSDK::Util::Request.prepare(headers, method, params, uri)
        request.basic_auth(@user, @password)
        connect_and_send(request, format: format)
      end
      # rubocop:enable Metrics/ParameterLists

      private

      ##
      # Set up and cache a Net::HTTP object to use when making requests.
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # :reek:TooManyStatements { enabled: false }
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
      # rubocop:enable Metrics/AbcSize

      ##
      # Send an HTTP request using the cached <tt>@http</tt> object and
      # return the JSON response body parsed into a hash. Also save the raw
      # Net::HTTP::Request and Net::HTTP::Response objects as
      # <tt>@last_request</tt> and <tt>@last_response</tt> to allow for
      # inspection later.
      # :reek:TooManyStatements { enabled: false }
      def connect_and_send(request, format: :json)
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
        Builder.handle(format, response)
      end
      # rubocop:enable Metrics/MethodLength

      class Builder
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def self.handle(format, response)
          if response.is_a?(Net::HTTPClientError)
            raise SmartcatSDK::REST::RequestError.new(response.body, response.code)
          end
          if response.body && !response.body.empty?
            builder_class = Builder.const_get(format.to_s.capitalize)
            builder_class.result(response)
          elsif response.is_a?(Net::HTTPBadRequest)
            {
              message: 'Bad request',
              code: 400
            }
          end
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        class Response
          def self.result(response)
            response
          end
        end

        class Body
          def self.result(response)
            response.body
          end
        end

        class Json
          def self.result(response)
            MultiJson.load(response.body)
          end
        end
      end
    end
  end
end
