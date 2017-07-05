require 'logger'

module Urbanairship
  module Loggable

    def logger
      Loggable.logger
    end

    def self.logger
      @logger ||= Loggable.create_logger
    end

    def self.create_logger
      log_filename = ENV.fetch('URBANAIRSHIP_LOG_FILENAME', 'urbanairship.log')
      log_level = ENV.fetch('URBANAIRSHIP_LOG_LEVEL', Logger::INFO)

      logger = Logger.new(log_filename)
      logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      logger.progname = 'Urbanairship'
      logger.level = log_level
      logger
    end
  end
end
