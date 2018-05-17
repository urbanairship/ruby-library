module Urbanairship
  class Configuration
    attr_accessor :log_path, :log_level, :timeout

    def initialize
      @log_path = nil
      @log_level = Logger::INFO
      @timeout = 5
    end
  end
end
