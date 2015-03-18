module Urbanairship
  module Response
    module InstanceMethods
      attr_accessor :ua_response, :ua_options, :original_request

      def code
        (ua_options[:code] || ua_response.code).to_s
      end

      def success?
        !!(code =~ /^2/)
      end

      def next_page
        if next_page_path && ua_client
          ua_client.send(:do_request, :get, next_page_path, original_request[:options])
        else
          nil
        end
      end

      private
      def next_page_path
        if self.is_a?(Hash) && self["next_page"]
          self["next_page"].to_s.match(/(\/api\/.*)$/).to_s
        else
          nil
        end
      end

      def ua_client
        client = original_request.is_a?(Hash) && original_request[:ua_client]
        if client == Urbanairship || client.is_a?(Urbanairship::Client)
          client
        else
          nil
        end
      end
    end

    def self.wrap(response, options = {})
      original_request = options.delete(:original_request)

      if options[:body]
        output = options[:body]
      else
        begin
          output = JSON.parse(response.body || '{}')
        rescue JSON::ParserError => e
          output = {}
        end
      end

      output.extend(Urbanairship::Response::InstanceMethods)
      output.ua_response = response
      output.ua_options = options
      output.original_request = original_request

      return output
    end
  end
end
