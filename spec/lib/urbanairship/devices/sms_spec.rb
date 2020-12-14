require 'spec_helper'

require 'urbanairship'
require 'urbanairship/devices/sms'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::Sms do
    opt_in_resp = {
      'body' => {
        'ok' => true,
        'channel_id' => '84e36d69-873b-4ffe-81cd-e74c9f002057'
      },
      'code'=> 201
    }

    without_opt_in_resp = {
      'body' => {
        'ok' => true,
        'status' => 'pending'
      },
      'code'=> 202
    }

    sms_accepted_resp = {
      'body' => {
        'ok' => true,
      },
      'code'=> 202
    }

    sms_lookup_resp = {
       "ok": true,
       "channel": {
          "channel_id": "84e36d69-873b-4ffe-81cd-e74c9f002057",
          "device_type": "sms",
          "installed": true,
          "push_address": nil,
          "named_user_id": nil,
          "alias": nil,
          "tags": [],
          "tag_groups": {
             "ua_channel_type": [
                "sms"
             ],
             "ua_sender_id": [
                "12345"
             ],
             "ua_opt_in": [
                "true"
             ]
          },
          "created": "2018-04-27T22:06:21",
          "opt_in": true,
          "last_registration": "2018-05-14T19:51:38"
       }
    }

    sms_update_resp = {
      "ok": true,
    } 

    describe '#register' do
      it 'can register an opted in sms channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(opt_in_resp)
        actual_resp = sms_channel.register
        expect(actual_resp).to eq(opt_in_resp)
      end

      it 'can register an opted in sms channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'

        allow(airship).to receive(:send_request).and_return(without_opt_in_resp)
        actual_resp = sms_channel.register
        expect(actual_resp).to eq(without_opt_in_resp)
      end

      it 'fails when not configured with a msisdn' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'

        expect{sms_channel.register}.to raise_error(ArgumentError)
      end

      it 'fails when not configured with a sender' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'

        expect{sms_channel.register()}.to raise_error(ArgumentError)
      end
    end

    describe '#update' do
      it 'can update an existing smms channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'
        sms_channel.timezone = 'America/Los_Angeles'
        sms_channel.channel_id = '1a2b3c4d'

        allow(airship).to receive(:send_request).and_return(sms_update_resp)
        actual_resp = sms_channel.update
        expect(actual_resp).to eq(sms_update_resp)
      end   
    end

    describe '#opt-out' do
      it 'can mark channel as opted out' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(sms_accepted_resp)
        actual_resp = sms_channel.opt_out
        expect(actual_resp).to eq(sms_accepted_resp)
      end

      it 'fails when not configured with sender' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        expect{sms_channel.opt_out}.to raise_error(ArgumentError)
      end

      it 'fails when not configured with a msisdn' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        expect{sms_channel.opt_out}.to raise_error(ArgumentError)
      end
    end

    describe '#uninstall' do
      it 'sms channel can be uninstalled with proper params' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(sms_accepted_resp)
        actual_resp = sms_channel.uninstall
        expect(actual_resp).to eq(sms_accepted_resp)
      end

      it 'fails when msisdn is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'

        expect{sms_channel.uninstall}.to raise_error(ArgumentError)
      end

      it 'fails when sender is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'

        expect{sms_channel.uninstall}.to raise_error(ArgumentError)
      end
    end

    describe '#Lookup' do
      it 'can get correct data from looking up a channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'

        allow(airship).to receive(:send_request).and_return(sms_lookup_resp)
        actual_resp = sms_channel.lookup
        expect(actual_resp). to eq(sms_lookup_resp)
      end

      it 'fails when sender is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'

        allow(airship).to receive(:send_request).and_return(sms_lookup_resp)
        expect{sms_channel.lookup}.to raise_error(ArgumentError)
      end

      it 'fails when sender is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'

        allow(airship).to receive(:send_request).and_return(sms_lookup_resp)
        expect{sms_channel.lookup}.to raise_error(ArgumentError)
      end
    end
  end
end
