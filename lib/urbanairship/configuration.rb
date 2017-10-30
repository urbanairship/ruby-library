module Urbanairship
  class Configuration
    attr_accessor :log_path, :log_level

    def initialize
      @log_path = nil
      @log_level = Logger::INFO
    end
  end
end
