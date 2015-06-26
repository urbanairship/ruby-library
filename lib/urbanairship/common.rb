require 'urbanairship/loggable'

module Urbanairship
  # Features mixed in to all classes
  module Common
    SERVER = 'go.urbanairship.com'
    BASE_URL = 'https://go.urbanairship.com/api'
    CHANNEL_URL = BASE_URL + '/channels/'
    DEVICE_TOKEN_URL = BASE_URL + '/device_tokens/'
    APID_URL = BASE_URL + '/apids/'
    DEVICE_PIN_URL = BASE_URL + '/device_pins/'
    PUSH_URL = BASE_URL + '/push/'
    DT_FEEDBACK_URL = BASE_URL + '/device_tokens/feedback/'
    APID_FEEDBACK_URL = BASE_URL + '/apids/feedback/'
    SCHEDULES_URL = BASE_URL + '/schedules/'
    TAGS_URL = BASE_URL + '/tags/'
    SEGMENTS_URL = BASE_URL + '/segments/'

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

      def from_response(response)
        """Instantiate a ValidationFailure from a Response object"""

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
      def self.check_code(response_code, response)
        if response_code == 401
          raise Unauthorized, "Client is not authorized to make this request. The authorization credentials are incorrect or missing."
        elsif response_code == 403
          raise Forbidden, "Client is not forbidden from making this request. The application does not have the proper entitlement to access this feature."
        elsif !((200 <= response_code) & (300 > response_code))
          raise AirshipFailure.new.from_response(response)
        end
      end
    end

  end
end
