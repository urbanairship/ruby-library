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

      def initialize(key: required('key'), secret: required('secret'))
        @key = key
        @secret = secret
      end

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

      def create_push
        Push::Push.new(self)
      end

      def create_scheduled_push
        Push::ScheduledPush.new(self)
      end
    end
  end
