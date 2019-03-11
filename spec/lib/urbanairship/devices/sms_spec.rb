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
        'channel_id' => '123'
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

    describe '#register' do
      it 'can register an opted in sms channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(opt_in_resp)
        actual_resp = sms_channel.register()
        expect(actual_resp).to eq(opt_in_resp)
      end

      it 'can register an opted in sms channel' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'

        allow(airship).to receive(:send_request).and_return(without_opt_in_resp)
        actual_resp = sms_channel.register()
        expect(actual_resp).to eq(without_opt_in_resp)
      end

      it 'fails when not configured with a msisdn' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'

        expect{sms_channel.register()}.to raise_error(ArgumentError)
      end

      it 'fails when not configured with a sender' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'

        expect{sms_channel.register()}.to raise_error(ArgumentError)
      end
    end

    describe '#opt-out' do
      it 'can mark channel as opted out' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(sms_accepted_resp)
        actual_resp = sms_channel.opt_out()
        expect(actual_resp).to eq(sms_accepted_resp)
      end

      it 'fails when not configured with sender' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        expect{sms_channel.opt_out()}.to raise_error(ArgumentError)
      end

      it 'fails when not configured with a msisdn' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        expect{sms_channel.opt_out()}.to raise_error(ArgumentError)
      end
    end

    describe '#uninstall' do
      it 'sms channel can be uninstalled with proper params' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms_channel.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(sms_accepted_resp)
        actual_resp = sms_channel.uninstall()
        expect(actual_resp).to eq(sms_accepted_resp)
      end

      it 'fails when msisdn is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.sender = '12345'

        expect{sms_channel.uninstall()}.to raise_error(ArgumentError)
      end

      it 'fails when sender is not set' do
        sms_channel = UA::Sms.new(client: airship)
        sms_channel.msisdn = '15035556789'

        expect{sms_channel.uninstall()}.to raise_error(ArgumentError)
      end
    end
  end
end
