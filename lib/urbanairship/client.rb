require 'net/http'
require 'uri'
require 'unirest'

module Urbanairship
    class Client
      attr_accessor :key, :secret
      def initialize(key:, secret:)
        @key = key
        @secret = secret
      end

      # @return [String] the HTTP response body
      def send_request(method:, body:, url:,
                       content_type: nil, version: nil, params: nil)
        case method
          when 'GET'
            response = Unirest.get(
                       url,
                       headers:{
                           "Content-type" => content_type,
                           "Accept" => "application/vnd.urbanairship+json; version=" + version.to_s
                       },
                       auth:{:user=>@key, :password=>@secret},
                       parameters: body
            )
            return {'body'=>response.body, 'code'=>response.code}
          when 'POST'
            response = Unirest.post(
                url,
                headers:{
                    "Content-type" => content_type,
                    "Accept" => "application/vnd.urbanairship+json; version=" + version.to_s
                },
                auth:{:user=>@key, :password=>@secret},
                parameters: body
            )
            return {'body'=>response.body, 'code'=>response.code}
          else
            fail 'Method was not "GET" or "POST"'
        end
      end

      def create_push
        PlainPush.new(self)
      end

      def create_scheduled_push
        ScheduledPush.new(self)
      end

    end
end
