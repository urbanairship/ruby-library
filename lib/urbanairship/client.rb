require 'net/http'
require 'uri'
require 'unirest'

module Urbanairship
    class Client
      # set default client timeout to 5 seconds
      Unirest.timeout(5)
      attr_accessor :key, :secret
      def initialize(key:, secret:)
        @key = key
        @secret = secret
      end

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
          when 'PUT'
            response = Unirest.put(
                url,
                headers:{
                    "Content-type" => content_type,
                    "Accept" => "application/vnd.urbanairship+json; version=" + version.to_s
                },
                auth:{:user=>@key, :password=>@secret},
                parameters: body
            )
            return {'body'=>response.body, 'code'=>response.code}
          when 'DELETE'
            response = Unirest.delete(
                url,
                headers:{
                    "Content-type" => content_type,
                    "Accept" => "application/vnd.urbanairship+json; version=" + version.to_s
                },
                auth:{:user=>@key, :password=>@secret},
                parameters: body
            )
            return {'body'=>nil, 'code'=>response.code}
          else
            fail 'Method was not "GET" "POST" "PUT" or "DELETE"'
        end
      end

      def create_push
        Push::Push.new(self)
      end

      def create_scheduled_push
        Push::ScheduledPush.new(self)
      end

    end
end
