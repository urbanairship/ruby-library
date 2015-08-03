require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::NamedUser do
    expected_resp = {
        'body' => {
            'ok' => true
        },
        'code' => 200
    }
    named_user = UA::NamedUser.new(airship, 'user_id')

    describe '#associate' do
      it 'associates a channel with a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = named_user.associate('123', 'android')
        expect(actual_resp).to eq(expected_resp)
      end
    end

    describe '#disassociate' do
      it 'disassociates a channel with a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = named_user.disassociate('123', 'android')
        expect(actual_resp).to eq(expected_resp)
      end
    end

    describe '#lookup' do
      it 'can look up a named_user' do
        expected_lookup_resp = {
          "body" => {
            "ok" => true,
            "named_user" => {
              "named_user_id" => "user-id-1234",
              "tags" => {
                "crm" => ["tag1", "tag2"]
              },
              "channels" => [
                {
                  "channel_id" => "ABCD",
                  "device_type" => "ios",
                  "installed" => true,
                  "opt_in" => true,
                  "push_address" => "FFFF",
                  "created" => "2013-08-08T20:41:06",
                  "last_registration" => "2014-05-01T18:00:27",
                  "alias" => "xxxx",
                  "ios" => {
                    "badge" => 0,
                    "quiettime" => {
                      "start" => "22:00",
                      "end" => "06:00"
                    },
                    "tz" => "America/Los_Angeles"
                  }
                }
              ]
            }
          },
          "code" => 200
        }
        allow(airship).to receive(:send_request).and_return(expected_lookup_resp)
        actual_resp = named_user.lookup
        expect(actual_resp).to eq(expected_lookup_resp)
      end
    end
  end

  describe Urbanairship::NamedUserTags do
    named_user_list = ['user1', 'user2', 'user3']
    named_user_tags = UA::NamedUserTags.new(airship)

    describe '#set_audience' do
      it 'can set the audience successfully' do
        named_user_tags.set_audience('test')
        expect(named_user_list) .to eq(named_user_list)
      end
    end
  end
end