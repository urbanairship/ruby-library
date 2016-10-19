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
      # @return [Object] Client
      def initialize(key: required('key'), secret: required('secret'))
        @key = key
        @secret = secret
      end

      # Send a request to Urban Airship's API
      #
      # @param [Object] method HTTP Method
      # @param [Object] body Request Body
      # @param [Object] url Request URL
      # @param [Object] content_type Content-Type
      # @param [Object] version API Version
      # @return [Object] Push Response
      def send_request(method: required('method'), url: required('url'), body: nil,
                       content_type: nil, encoding: nil)
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

        debug = "Making #{method} request to #{url}.\n"+
            "\tHeaders:\n"
        debug += "\t\tcontent-type: #{content_type}\n" unless content_type.nil?
        debug += "\t\tcontent-encoding: gzip\n" unless encoding.nil?
        debug += "\t\taccept: application/vnd.urbanairship+json; version=3\n"
        debug += "\tBody:\n#{body}" unless body.nil?

        logger.debug(debug)

        response = RestClient::Request.execute(
          method: method,
          url: url,
          headers: headers,
          user: @key,
          password: @secret,
          payload: body,
          timeout: 5,
          verify_ssl: false
        )

        logger.debug("Received #{response.code} response. Headers:\n\t#{response.headers}\nBody:\n\t#{response.body}")

        Response.check_code(response.code, response)

        {'body'=>response.body, 'code'=>response.code, 'headers'=>response.headers}
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
    end
  end
