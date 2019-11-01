require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/email'
require 'urbanairship/devices/sms'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::CreateAndSend do

    email_response = {
        "ok": true,
        "operation_id": "67c65146-c27f-431f-b54a-83aca694fdd3",
        "push_ids": [
            "c0eead17-333b-4f86-8a42-9fb7be1ed627"
        ],
        "message_ids": [],
        "content_urls": []
    }
  end
end
