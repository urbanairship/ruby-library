require 'json'
require 'net/https'
require 'time'

module Urbanairship
  begin
    require 'system_timer'
    Timer = SystemTimer
  rescue LoadError
    require 'timeout'
    Timer = Timeout
  end

  VALID_REGISTER_PARAMS = %w(alias)

  class << self
    attr_accessor :application_key, :application_secret, :master_secret, :logger, :request_timeout

    def register_device(device_token, options = {})
      response = do_request(:put, "/api/device_tokens/#{device_token}", :authenticate_with => :application_secret) do |request|
        request.body = parse_register_options(options).to_json
        request.add_field "Content-Type", "application/json" unless options.empty?
      end

      response && %w(200 201).include?(response.code)
    end

    def unregister_device(device_token)
      response = do_request(:delete, "/api/device_tokens/#{device_token}", :authenticate_with => :application_secret)
      response && response.code == "204"
    end

    def delete_scheduled_push(param)
      path = (param.is_a? Hash) ? "/api/push/scheduled/alias/#{param[:alias].to_s}" : "/api/push/scheduled/#{param.to_s}"
      response = do_request(:delete, path, :authenticate_with => :master_secret)
      response && response.code == "204"
    end

    def push(options = {})
      response = do_request(:post, "/api/push/", :authenticate_with => :master_secret) do |request|
        request.body = parse_push_options(options).to_json
        request.add_field "Content-Type", "application/json"
      end

      response && response.code == "200"
    end

    def batch_push(notifications = [])
      response = do_request(:post, "/api/push/batch/", :authenticate_with => :master_secret) do |request|
        request.body = notifications.map{|notification| parse_push_options(notification)}.to_json
        request.add_field "Content-Type", "application/json"
      end

      response && response.code == "200"
    end

    def broadcast_push(options = {})
      response = do_request(:post, "/api/push/broadcast/", :authenticate_with => :master_secret) do |request|
        request.body = parse_push_options(options).to_json
        request.add_field "Content-Type", "application/json"
      end

      response && response.code == "200"
    end

    def feedback(time)
      response = do_request(:get, "/api/device_tokens/feedback/?since=#{format_time(time)}", :authenticate_with => :master_secret)
      response && response.code == "200" ? JSON.parse(response.body) : false
    end

  private

    def do_request(http_method, path, options = {})
      verify_configuration_values(:application_key, options[:authenticate_with])

      klass = Net::HTTP.const_get(http_method.to_s.capitalize)

      request = klass.new(path)
      request.basic_auth @application_key, instance_variable_get("@#{options[:authenticate_with]}")

      yield(request) if block_given?

      Timer.timeout(request_timeout) do
        start_time = Time.now
        response = http_client.request(request)
        log_request_and_response(request, response, Time.now - start_time)
        response
      end
    rescue Timeout::Error
      logger.error "Urbanairship request timed out after #{request_timeout} seconds: [#{http_method} #{request.path} #{request.body}]"
      return false
    end

    def verify_configuration_values(*symbols)
      absent_values = symbols.select{|symbol| instance_variable_get("@#{symbol}").nil? }
      raise("Must configure #{absent_values.join(", ")} before making this request.") unless absent_values.empty?
    end

    def http_client
      Net::HTTP.new("go.urbanairship.com", 443).tap{|http| http.use_ssl = true}
    end

    def parse_register_options(hash = {})
      hash[:alias] = hash[:alias].to_s unless hash[:alias].nil?
      hash.delete_if{|key, value| !VALID_REGISTER_PARAMS.include?(key.to_s)}
    end

    def parse_push_options(hash = {})
      hash[:schedule_for] = hash[:schedule_for].map{|elem| process_scheduled_elem(elem)} unless hash[:schedule_for].nil?
      hash
    end

    def log_request_and_response(request, response, time)
      return if logger.nil?

      time = (time * 1000).to_i
      http_method = request.class.to_s.split('::')[-1]
      logger.info "Urbanairship (#{time}ms): [#{http_method} #{request.path}, #{request.body}], [#{response.code}, #{response.body}]"
      logger.flush if logger.respond_to?(:flush)
    end

    def format_time(time)
      time = Time.parse(time) if time.is_a?(String)
      time.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    def process_scheduled_elem(elem)
      if elem.class == Hash
        elem.merge!(:scheduled_time => format_time(elem[:scheduled_time]))
      else
        format_time(elem)
      end
    end

    def request_timeout
      @request_timeout || 5.0
    end
  end
end
