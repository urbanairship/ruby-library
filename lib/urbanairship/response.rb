module Urbanairship
  module Response
    module InstanceMethods
      attr_accessor :ua_response, :ua_options

      def code
        (ua_options[:code] || ua_response.code).to_s
      end

      def success?
        !!(code =~ /^2/)
      end
    end

    def self.wrap(response, options = {})
      if options[:body]
        output = options[:body]
      else
        begin
          output = JSON.parse(response.body || '{}')
        rescue JSON::ParserError
          output = {}
        end
      end

      output.extend(Urbanairship::Response::InstanceMethods)
      output.ua_response = response
      output.ua_options = options

      return output
    end
  end
end
