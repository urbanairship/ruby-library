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
    channel_info = UA::ChannelInfo.new(airship)

    describe '#lookup' do
      it 'can get a response' do
        allow(airship).to receive(:send_request).and_return(lookup_hash)
        response = channel_info.lookup('321')
        expect(response[:channel_id]).to eq '123'
      end
    end
  end

  describe Urbanairship::Devices::ChannelList do
    channel_list_hash = {
      'body' => {
        'channels' => [
          {
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
          },
          {
            :channel_id => '124',
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
        ]
      }
    }

    channel_list_hash_cont = {
      'body' => {
        'channels' => [
          {
            :channel_id => '125',
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
          },
          {
            :channel_id => '126',
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
        ]
      }
    }

    channel_id_list = %w(126 125 124 123)

    it 'can iterate through a response' do
      allow(airship).to receive(:send_request)
        .and_return(channel_list_hash, channel_list_hash_cont)
      channel_list = UA::ChannelList.new(airship)
      channel_list.each do |channel|
        expect(channel[:channel_id]).to eq channel_id_list.pop
      end
    end
  end
end