require 'urbanairship/version'
require 'urbanairship/push/payload'
require 'urbanairship/push/audience'

module Urbanairship
  # Make these functions available in the
  # `Urbanairship` namespace, as in the Python
  # library.
  extend Urbanairship::Push::Payload
  extend Urbanairship::Push::Audience
end
