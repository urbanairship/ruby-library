require 'spec_helper'
require 'urbanairship'

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

    describe '#register' do
      it 'can register an opted in sms channel' do
        sms_channel = UA::OpenChannel.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'
        sms.opted_in = '2018-02-13T11:58:59'

        allow(airship).to receive(:send_request).and_return(opt_in_resp)
        actual_resp = sms_channel.register()
        expect(actual_resp).to eq(opt_in_resp)
      end

      it 'can register an opted in sms channel' do
        sms_channel = UA::OpenChannel.new(client: airship)
        sms_channel.msisdn = '15035556789'
        sms_channel.sender = '12345'

        allow(airship).to receive(:send_request).and_return(without_opt_in_resp)
        actual_resp = sms_channel.register()
        expect(actual_resp).to eq(without_opt_in_resp)
      end

      it 'fails when not configured with a sender' do

      end
    end
  end


  # HTTP/1.1 400 Bad Request
  # Content-Type: application/json
  #
  # {
  #     "ok": false,
  #     "errors": "Unable to retrieve details for sender 12345 with app_key <application key>"
  # }
  #request
  # POST /api/channels/sms HTTP/1.1
  # Authorization: Basic <application authorization string>
  # Accept: application/vnd.urbanairship+json; version=3;
  # Content-type: application/json
  #
  # {
  #     "msisdn" : "15035556789",
  #     "sender": "12345",
  #     "opted_in": "2018-02-13T11:58:59"
  # }
