require 'spec_helper'

require 'urbanairship'
require 'urbanairship/client'
require 'urbanairship/devices/devicelist'

describe Urbanairship::Devices do
  describe Urbanairship::Devices::ChannelInfo do
    lookup_hash = {
        :channel_id => '123',
        :device_type => 'ios',
        :installed => true,
        :opt_in => false,
        :push_address => 'FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660',
        :created => '2013-08-08T20:41:06',
        :last_registration => '2014-05-01T18:00:27',
        :alias => 'your_user_id',
        :tags => %w(tag1 tag2),
        :tag_groups => {
            :tag_group_1 => %w(tag1 tag2),
            :tag_group_2 => %w(tag1 tag2)
        },
        :ios => {
            :badge => 0,
            :quiettime => {
                :start => null,
                :end => null
            },
            :tz => 'America/Los_Angeles'
        }
    }

    let(:expected_lookup) { lookup_hash }

    describe '#lookup' do
      it 'can get a response' do
        airship = UA::Client.new(key: '123', secret: 'abc')
        channel_info = UA::Devices::ChannelInfo.new(airship)
        allow(airship)
            .to receive(:send_request)
                    .and_return(expected_lookup)
        response = channel_info.lookup('321')
        expect(response['channel_id']).to eq '123'
      end
    end

  end
end