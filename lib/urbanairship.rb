require 'urbanairship/custom_events/custom_event'
require 'urbanairship/custom_events/payload'
require 'urbanairship/push/audience'
require 'urbanairship/push/payload'
require 'urbanairship/push/schedule'
require 'urbanairship/push/push'
require 'urbanairship/devices/segment'
require 'urbanairship/devices/channel_uninstall'
require 'urbanairship/devices/sms'
require 'urbanairship/devices/email'
require 'urbanairship/devices/email_notification'
require 'urbanairship/devices/sms_notification'
require 'urbanairship/devices/mms_notification'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/attribute'
require 'urbanairship/devices/attributes'
require 'urbanairship/client'
require 'urbanairship/common'
require 'urbanairship/configuration'
require 'urbanairship/loggable'
require 'urbanairship/util'
require 'urbanairship/version'
require 'urbanairship/devices/devicelist'
require 'urbanairship/devices/channel_tags'
require 'urbanairship/devices/named_user'
require 'urbanairship/devices/open_channel'
require 'urbanairship/reports/response_statistics'
require 'urbanairship/devices/static_lists'
require 'urbanairship/devices/subscription_lists'
require 'urbanairship/push/location'
require 'urbanairship/automations/pipeline'
require 'urbanairship/automations/automation'
require 'urbanairship/ab_tests/variant'
require 'urbanairship/ab_tests/experiment'
require 'urbanairship/ab_tests/ab_test'

module Urbanairship
  extend Urbanairship::CustomEvents::Payload
  extend Urbanairship::CustomEvents
  extend Urbanairship::Push::Audience
  extend Urbanairship::Push::Payload
  extend Urbanairship::Push::Schedule
  extend Urbanairship::Push
  include Urbanairship::CustomEvents
  include Urbanairship::Devices
  include Urbanairship::Reports
  include Urbanairship::Push
  include Urbanairship::Automations
  include Urbanairship::AbTests

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
