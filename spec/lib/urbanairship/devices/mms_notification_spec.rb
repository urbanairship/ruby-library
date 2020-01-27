require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/mms_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

end
