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
      fail 'Not implemented yet.'
    end

    def create_push
      Push.new(self)
    end

    def create_scheduled_push
      ScheduledPush.new(self)
    end
  end
end
