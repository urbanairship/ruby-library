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
      log_uri = [Urbanairship.configuration.log_path, 'urbanairship.log'].compact
      logger = Logger.new(File.join(*log_uri))
      logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      logger.progname = 'Urbanairship'
      logger
    end
  end
end
