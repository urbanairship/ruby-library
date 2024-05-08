module Urbanairship
  class Configuration
    attr_accessor :custom_logger, :log_path, :log_level, :server, :oauth_server, :timeout

    def initialize
      @server = 'api.asnapius.com'
      @oauth_server = 'oauth2.asnapius.com'
      @custom_logger = nil
      @log_path = nil
      @log_level = Logger::INFO
      @timeout = 60
    end
  end
end
