# TODO find a better way to bring these all in
require 'urbanairship/push/audience'
require 'urbanairship/push/payload'
require 'urbanairship/push/schedule'
require 'urbanairship/push/push'
require 'urbanairship/client'
require 'urbanairship/common'
require 'urbanairship/loggable'
require 'urbanairship/util'
require 'urbanairship/version'

module Urbanairship
  # Make these functions available in the
  # `Urbanairship` namespace, as in the Python
  # library.
  extend Urbanairship::Push::Audience
  extend Urbanairship::Push::Payload
  extend Urbanairship::Push::Schedule
  extend Urbanairship::Push

end
