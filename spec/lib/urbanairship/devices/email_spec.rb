require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/email'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::Email do
    register_response = {
      "ok": true,
      "channel_id": "251d3318-b3cb-4e9f-876a-ea3bfa6e47bd"
    }

    describe '#register' do
      it 'can register email channel' do
        email_channel = UA::Email.new(client: airship)
        email_channel.type = 'email'
        email_channel.commercial_opted_in = '2018-10-28T10:34:22'
        email_channel.address = 'finnthehuman@adventure.com'
        email_channel.timezone = 'America/Los_Angeles'
        email_channel.locale_country = 'US'
        email_channel.locale_language = 'en'

        allow(airship).to receive(:send_request).and_return(register_response)
        actual_resp = email_channel.register
        expect(actual_resp).to eq(register_response)
      end

      it 'fails when address is not set' do
        email_channel = UA::Email.new(client: airship)
        email_channel.type = 'email'
        email_channel.commercial_opted_in = '2018-10-28T10:34:22'
        email_channel.timezone = 'America/Los_Angeles'
        email_channel.locale_country = 'US'
        email_channel.locale_language = 'en'

        expect{email_channel.register()}.to raise_error(ArgumentError)
      end
    end
  end
end
