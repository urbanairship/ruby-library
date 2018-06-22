require 'urbanairship/loggable'


module Urbanairship
  # Features mixed in to all classes
  module Common
    SERVER = 'go.urbanairship.com'
    BASE_URL = 'https://go.urbanairship.com/api'
    CHANNEL_URL = BASE_URL + '/channels/'
    OPEN_CHANNEL_URL = BASE_URL + '/channels/open/'
    DEVICE_TOKEN_URL = BASE_URL + '/device_tokens/'
    APID_URL = BASE_URL + '/apids/'
    PUSH_URL = BASE_URL + '/push/'
    SCHEDULES_URL = BASE_URL + '/schedules/'
    SEGMENTS_URL = BASE_URL + '/segments/'
    NAMED_USER_URL = BASE_URL + '/named_users/'
    REPORTS_URL = BASE_URL + '/reports/'
    LISTS_URL = BASE_URL + '/lists/'
    PIPELINES_URL = BASE_URL + '/pipelines/'
    FEEDS_URL = BASE_URL + '/feeds/'
    LOCATION_URL = BASE_URL + '/location/'

    # Helper method for required keyword args in Ruby 2.0 that is compatible with 2.1+
    # @example
    #   def say(greeting: required('greeting'))
    #     puts greeting
    #   end
    #
    #   >> say
    #   >> test.rb:3:in `required': required parameter :greeting not passed to method say (ArgumentError)
    #   >>       from test.rb:6:in `say'
    #   >>       from test.rb:18:in `<main>'
    # @param [Object] arg optional argument name
    def required(arg=nil)
      method = caller_locations(1,1)[0].label
      raise ArgumentError.new("required parameter #{arg.to_sym.inspect + ' ' if arg}not passed to method #{method}")
    end

    # Helper method that sends the indicated method to the indicated object, if the object responds to the method
    # @example
    #   try_helper(:first, [1,2,3])
    #
    #   >> 1
    def try_helper(method, obj)
      if obj.respond_to?(method)
        obj.send(method)
      end
    end

    # Helper method that deletes every key-value pair from a hash for which the value is nil
    # @example
    #   compact_helper({"a" => 1, "b" => nil})
    #
    #   >> {"a" => 1}
    def compact_helper(a_hash)
      a_hash.keep_if {|_, value| !value.nil?}
    end

    class Unauthorized < StandardError
      # raised when we get a 401 from server
    end

    class Forbidden < StandardError
      # raised when we get a 403 from server
    end

    class AirshipFailure < StandardError
      include Urbanairship::Loggable
      # Raised when we get an error response from the server.
      attr_accessor :error, :error_code, :details, :response

      def initialize
        @error = nil
        @error_code = nil
        @details = nil
        @response = nil
      end

      # Instantiate a ValidationFailure from a Response object
      def from_response(response)

        payload = response.body
        @error = payload['error']
        @error_code = payload['error_code']
        @details = payload['details']
        @response = response

        logger.error("Request failed with status #{response.code.to_s}: '#{@error_code} #{@error}': #{response.body}")

        self
      end

    end

    class Response
      # Parse Response Codes and trigger appropriate actions.
      def self.check_code(response_code, response)
        if response_code == 401
          raise Unauthorized, 'Client is not authorized to make this request. The authorization credentials are incorrect or missing.'
        elsif response_code == 403
          raise Forbidden, 'Client is forbidden from making this request. The application does not have the proper entitlement to access this feature.'
        elsif !((200...300).include?(response_code))
          raise AirshipFailure.new.from_response(response)
        end
      end
    end

    class PageIterator
      include Urbanairship::Common
      include Urbanairship::Loggable
      include Enumerable
      attr_accessor :data_attribute

      def initialize(client: required('client'))
        @client = client
        @next_page = nil
        @data_list = nil
        @data_attribute = nil
        @count = 0
      end

      def load_page
        return false unless @next_page
        response = @client.send_request(
            method: 'GET',
            url: @next_page
        )
        logger.info("Retrieving data from: #{@next_page}")
        check_next_page = response['body']['next_page']
        if check_next_page != @next_page
          @next_page = check_next_page
        elsif check_next_page
          # if check_page = next_page, we have repeats in the response.
          # and we don't want to load them
          return false
        else
          @next_page = nil
        end
        @data_list = response['body'][@data_attribute]
        true
      end

      def each
        while load_page
          @data_list.each do | value |
            @count += 1
            yield value
          end
        end
      end

      def count
        @count
      end
    end
  end
end
