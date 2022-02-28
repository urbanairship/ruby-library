require 'urbanairship/loggable'


module Urbanairship
  # Features mixed in to all classes
  module Common
    CONTENT_TYPE = 'application/json'

    def apid_path(path='')
      "/apids/#{path}"
    end

    def channel_path(path='')
      "/channels/#{path}"
    end

    def create_and_send_path(path='')
      "/create-and-send/#{path}"
    end

    def custom_events_path(path='')
      "/custom-events/#{path}"
    end

    def device_token_path(path='')
      "/device_tokens/#{path}"
    end

    def experiments_path(path='')
      "/experiments/#{path}"
    end

    def lists_path(path='')
      "/lists/#{path}"
    end

    def named_users_path(path='')
      "/named_users/#{path}"
    end

    def open_channel_path(path='')
      "/open/#{path}"
    end

    def pipelines_path(path='')
      "/pipelines/#{path}"
    end

    def push_path(path='')
      "/push/#{path}"
    end

    def reports_path(path='')
      "/reports/#{path}"
    end

    def schedules_path(path='')
      "/schedules/#{path}"
    end

    def segments_path(path='')
      "/segments/#{path}"
    end

    def tag_lists_path(path='')
      "/tag-lists/#{path}"
    end

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
        @count = 0
        @data_attribute = nil
        @data_list = nil
        @next_page_path = nil
        @next_page_url = nil
      end

      def each
        while @next_page_path || @next_page_url
          load_page

          @data_list.each do |value|
            @count += 1
            yield value
          end
        end
      end

      def count
        @count
      end

      private

      def load_page
        logger.info("Retrieving data from: #{@next_page_url || @next_page_path}")
        params = {
            method: 'GET',
            path: @next_page_path,
            url: @next_page_url
          }.select { |k, v| !v.nil? }
        response = @client.send_request(params)

        @data_list = get_new_data(response)
        @next_page_url = get_next_page_url(response)
        @next_page_path = nil
      end

      def extract_next_page_url(response)
        response['body']['next_page']
      end

      def get_new_data(response)
        potential_next_page_url = extract_next_page_url(response)

        # if potential_next_page_url is the same as the current page, we have
        # repeats in the response and we don't want to load them
        return [] if potential_next_page_url && get_next_page_url(response).nil?

        response['body'][@data_attribute]
      end

      def get_next_page_url(response)
        potential_next_page_url = extract_next_page_url(response)
        return nil if potential_next_page_url.nil?

        # if potential_next_page_url is the same as the current page, we have
        # repeats in the response and we don't want to check the next pages
        return potential_next_page_url if @next_page_url && potential_next_page_url != @next_page_url
        return potential_next_page_url if @next_page_path && !potential_next_page_url.end_with?(@next_page_path)
        nil
      end
    end
  end
end
