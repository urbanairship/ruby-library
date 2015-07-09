require 'unirest'
require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
    class Client
      attr_accessor :key, :secret
      include Urbanairship::Common
      include Urbanairship::Loggable

      # set default client timeout to 5 seconds
      Unirest.timeout(5)

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
      # @param [Object] params Parameters
      # @return [Object] Push Response
      def send_request(method: required('method'), body: required('body'), url: required('url'),
                       content_type: nil, version: nil, params: nil)
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

        logger.debug("Making #{method} request to #{url}. \n\tHeaders:\n\tcontent-type: #{content_type}\n\tversion=#{version.to_s}\nBody:\n\t#{body}")

        response = Unirest.method(req_type).call(
            url,
            headers:{
                "Content-type" => content_type,
                "Accept" => "application/vnd.urbanairship+json; version=" + version.to_s
            },
            auth:{
                :user=>@key,
                :password=>@secret
            },
            parameters: body
        )

        logger.debug("Received #{response.code} response. Headers:\n\t#{response.headers}\nBody:\n\t#{response.body}")

        Response.check_code(response.code, response)

        {'body'=>response.body, 'code'=>response.code}
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
