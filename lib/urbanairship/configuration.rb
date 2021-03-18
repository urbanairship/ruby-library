module Urbanairship
  class Configuration
    attr_accessor :custom_logger, :log_path, :log_level, :server, :timeout

    def initialize
      @server = 'go.urbanairship.com'
      @custom_logger = nil
      @log_path = nil
      @log_level = Logger::INFO
      @timeout = 60
    end
  end
end
