require 'urbanairship'
require 'urbanairship/http_client'

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

        headers = { "User-Agent"  => "UARubyLib/" + Urbanairship::VERSION }
        headers["Accept"] = "application/vnd.urbanairship+json; version=3"
        headers['Content-type'] = content_type unless content_type.nil?
        headers['Content-Encoding'] = encoding unless encoding.nil?

        debug = "Making #{method} request to #{url}.\n"+
            "\tHeaders:\n"
        debug += "\t\tcontent-type: #{content_type}\n" unless content_type.nil?
        debug += "\t\tcontent-encoding: gzip\n" unless encoding.nil?
        debug += "\t\taccept: application/vnd.urbanairship+json; version=3\n"
        debug += "\tBody:\n#{body}" unless body.nil?

        logger.debug(debug)

        response = HttpClient.request(method, {
          uri: url,
          headers: headers,
          auth: {
            username: @key,
            password: @secret,
          },
          parameters: body
        })

        logger.debug("Received #{response.code} response. Headers:\n\t#{response.headers}\nBody:\n\t#{response.body}")

        Response.check_code(response.code, response)

        response
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
