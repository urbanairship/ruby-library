require 'urbanairship/push/audience'
require 'urbanairship/push/payload'
require 'urbanairship/push/schedule'
require 'urbanairship/push/push'
require 'urbanairship/client'
require 'urbanairship/common'
require 'urbanairship/loggable'
require 'urbanairship/util'
require 'urbanairship/version'
require 'urbanairship/devices/devicelist'
require 'urbanairship/devices/channel_tags'
require 'urbanairship/devices/named_user'
require 'urbanairship/reports/per_push'

module Urbanairship
  extend Urbanairship::Push::Audience
  extend Urbanairship::Push::Payload
  extend Urbanairship::Push::Schedule
  extend Urbanairship::Push
  include Urbanairship::Devices
  include Urbanairship::Reports
end
