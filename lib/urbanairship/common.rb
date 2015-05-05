require 'logger'

module Urbanairship

  # Features mixed in to all classes
  module Common
    SERVER = 'go.urbanairship.com'
    BASE_URL = "https://go.urbanairship.com/api"
    CHANNEL_URL = BASE_URL + '/channels/'
    DEVICE_TOKEN_URL = BASE_URL + '/device_tokens/'
    APID_URL = BASE_URL + '/apids/'
    DEVICE_PIN_URL = BASE_URL + '/device_pins/'
    PUSH_URL = BASE_URL + '/push/'
    DT_FEEDBACK_URL = BASE_URL + '/device_tokens/feedback/'
    APID_FEEDBACK_URL = BASE_URL + '/apids/feedback/'
    SCHEDULES_URL = BASE_URL + '/schedules/'
    TAGS_URL = BASE_URL + '/tags/'
    SEGMENTS_URL = BASE_URL + '/segments/'

    def logger
      if @logger.nil?
        @logger = Logger.new('urbanairship.log')
        @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
        @logger.progname = 'Urbanairship'
      end
      @logger
    end
  end

end
