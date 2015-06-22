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
        req_type = case method
          when 'GET'
            :get
          when 'POST'
            :post
          when "PUT"
            :put
          when 'DELETE'
            :delete
          else
            fail 'Method was not "GET" "POST" "PUT" or "DELETE"'
        end

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
