require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::ChannelInfo do
    lookup_hash = {
      'body' => {
        'channel' => {
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
              :start => nil,
              :end => nil
            },
            :tz => 'America/Los_Angeles'
          }
        }
      }
    }
    channel_info = UA::ChannelInfo.new(client: airship)

    describe '#lookup' do
      it 'can get a response' do
        allow(airship).to receive(:send_request).and_return(lookup_hash)
        response = channel_info.lookup(uuid: '321')
        expect(response[:channel_id]).to eq '123'
      end
    end
  end

  describe Urbanairship::Devices::ChannelList do
    channel_list_item = {
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
          :start => nil,
          :end => nil
        },
        :tz => 'America/Los_Angeles'
      }
    }

    channel_list_hash = {
      'body' => {
        'channels' => [ channel_list_item, channel_list_item, channel_list_item ],
        'next_page' => 'next_url'
      },
      'code' => 200
    }

    channel_list_hash2 = {
      'body' => {
        'channels' => [ channel_list_item, channel_list_item, channel_list_item ],
        'next_page' => 'next_url'
      },
      'code' => 200
    }

    channel_list_hash3 = {
        'body' => {
            'channels' => [ channel_list_item, channel_list_item, channel_list_item ],
        },
        'code' => 200
    }

    it 'can iterate through a response' do
      instantiated_list = Array.new
      allow(airship).to receive(:send_request)
        .and_return(channel_list_hash, channel_list_hash2, channel_list_hash3)
      channel_list = UA::ChannelList.new(client: airship)
      channel_list.each do |channel|
        expect(channel).to eq(channel_list_item)
        instantiated_list.push(channel)
      end
      expect(instantiated_list.size).to eq(9)
    end
  end
end