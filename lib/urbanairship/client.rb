require 'json'
require 'rest-client'
require 'urbanairship'


module Urbanairship
    class Client
      attr_accessor :key, :secret
      include Urbanairship::Common
      include Urbanairship::Loggable

      # Initialize the Client
      #
      # @param [Object] key Application Key
      # @param [Object] secret Application Secret
      # @param [String] token Application Auth Token (for custom events endpoint)
      # @return [Object] Client
      def initialize(key: required('key'), secret: required('secret'), token: nil)
        @key = key
        @secret = secret
        @token = token
      end

      # Send a request to Airship's API
      #
      # @param [Object] method HTTP Method
      # @param [Object] body Request Body
      # @param [Object] url Request URL
      # @param [Object] content_type Content-Type
      # @param [Object] encoding Encoding
      # @param [Symbol] auth_type (:basic|:bearer)
      # @return [Object] Push Response
      def send_request(method: required('method'), url: required('url'), body: nil,
                       content_type: nil, encoding: nil, auth_type: :basic)
        req_type = case method
          when 'GET'
            :get
          when 'POST'
            :post
          when 'PUT'
            :put
          when 'DELETE'
            :delete
          else
            fail 'Method was not "GET" "POST" "PUT" or "DELETE"'
        end

        headers = {'User-agent' => 'UARubyLib/' + Urbanairship::VERSION}
        headers['Accept'] = 'application/vnd.urbanairship+json; version=3'
        headers['Content-type'] = content_type unless content_type.nil?
        headers['Content-Encoding'] = encoding unless encoding.nil?
        if auth_type == :bearer
          raise ArgumentError.new('token must be provided as argument if auth_type=bearer') if @token.nil?

          headers['X-UA-Appkey'] = @key
          headers['Authorization'] = "Bearer #{@token}"
        end

        debug = "Making #{method} request to #{url}.\n"+ "\tHeaders:\n"
        debug += "\t\tcontent-type: #{content_type}\n" unless content_type.nil?
        debug += "\t\tcontent-encoding: gzip\n" unless encoding.nil?
        debug += "\t\taccept: application/vnd.urbanairship+json; version=3\n"
        debug += "\tBody:\n#{body}" unless body.nil?

        logger.debug(debug)

        params = {
          method: method,
          url: url,
          headers: headers,
          payload: body,
          timeout: Urbanairship.configuration.timeout
        }

        if auth_type == :basic
          params[:user] = @key
          params[:password] = @secret
        end

        response = RestClient::Request.execute(params)

        logger.debug("Received #{response.code} response. Headers:\n\t#{response.headers}\nBody:\n\t#{response.body}")
        Response.check_code(response.code, response)

        self.class.build_response(response)
      end

      # Create a Push Object
      #
      # @return [Object] Push Object
      def create_push
        Push::Push.new(self)
      end

      # Create a Scheduled Push Object
      #
      # @return [Object] Scheduled Push Object
      def create_scheduled_push
        Push::ScheduledPush.new(self)
      end

      # Build a hash from the response object
      #
      # @return [Hash] The response body.
      def self.build_response(response)
        response_hash = {'code'=>response.code.to_s, 'headers'=>response.headers}

        begin
          body = JSON.parse(response.body)
        rescue JSON::ParserError
          if response.body.nil? || response.body.empty?
            body = {}
          else
            body = response.body
            response_hash['error'] = 'could not parse response JSON'
          end
        end

        response_hash['body'] = body
        response_hash
      end
    end
  end
