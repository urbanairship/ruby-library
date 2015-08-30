require 'logger'


module Urbanairship
  module Loggable

    def logger
      @logger ||= create_logger
    end

    def create_logger
      logger = Logger.new('urbanairship.log')
      logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      logger.progname = 'Urbanairship'
      logger
    end

  end
end
