module Urbanairship
  class HttpClient

    # Make an HTTP Request
    def self.request(*args)
      HttpClient::Request.new(*args).send_request
    end

    class Response
      attr_reader :body, :code, :headers

      def initialize(http_response)
        @body    = parse_json(http_response.body)
        @code    = http_response.code.to_i
        @headers = http_response.each_header.to_a
      end

      def [](attribute)
        send(attribute) if respond_to?(attribute)
      end

      private

      def parse_json(body)
        JSON.parse(body.to_s)
      rescue JSON::ParserError
        {}
      end
    end

    class Request
      attr_reader :method, :uri, :headers, :parameters, :auth

      def initialize(method, uri:, headers: {}, parameters: {}, auth: nil)
        @method     = method.downcase.to_sym
        @uri        = URI(uri)
        @headers    = headers
        @parameters = parameters || {}
        @auth       = auth
        @request    = build_request
      end

      def send_request
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = 5

        headers.each do |header, value|
          @request[header] = value
        end

        if auth
          @request.basic_auth(auth[:username], auth[:password])
        end

        begin
          response = http.request(@request)
        rescue Net::HTTPRequestTimeOut
          raise 'Request timeout'
        end

        HttpClient::Response.new(response)
      end

      private

      def build_request
        case method
        when :get
          if parameters.any?
            uri.query = URI.encode_www_form(parameters)
          end

          Net::HTTP::Get.new(uri, headers)
        when :post
          req = Net::HTTP::Post.new(uri, headers)
          req.body = parameters
          req
        when :put
          req = Net::HTTP::Put.new(uri, headers)
          req.body = parameters
        when :delete
          req = Net::HTTP::Delete.new(uri, headers)
          req.body = parameters
        else
          fail 'Method was not "GET" "POST" "PUT" or "DELETE"'
        end
      end
    end

  end
end
