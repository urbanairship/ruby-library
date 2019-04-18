module Urbanairship
  class Configuration
    attr_accessor :custom_logger, :log_path, :log_level, :timeout

    def initialize
      @custom_logger = nil
      @log_path = nil
      @log_level = Logger::INFO
      @timeout = 5
    end
  end
end
