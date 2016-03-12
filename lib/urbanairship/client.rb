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

        uri       = URI(url)
        http      = Net::HTTP.new(uri.host, uri.port)
        request   = nil

        http.use_ssl = true
        http.read_timeout = 5

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

        case method
        when :get, "GET"
          uri.query = URI.encode_www_form(body)
          request = Net::HTTP::Get.new(uri, headers)
        when :post, "POST"
          request = Net::HTTP::Post.new(uri, headers)
          request.body = body
        when :put, "PUT"
          request = Net::HTTP::Put.new(uri, headers)
          request.body = body
        when :delete, "DELETE"
          request = Net::HTTP::Delete.new(uri, headers)
          request.body = body
        else
          fail 'Method was not "GET" "POST" "PUT" or "DELETE"'
        end

        request.basic_auth(@key, @secret)

        response = http.request(request)

        response_body     = JSON.parse(response.body)
        response_code     = response.code.to_i
        response_headers  = Hash[response.each_header.to_a]

        logger.debug("Received #{response_code} response. Headers:\n\t#{response_headers}\nBody:\n\t#{response_body}")

        Response.check_code(response_code, response)

        {'body'=>response_body, 'code'=>response_code, 'headers'=>response_headers}
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
