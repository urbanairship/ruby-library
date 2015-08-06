require 'spec_helper'
require 'urbanairship'
require 'time'


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
        response = channel_info.lookup(uuid: '321')
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

  describe Urbanairship::Devices::Feedback do
    feedback = UA::Feedback.new(airship)

    describe '#device_token' do
      it 'can get the device_list' do
        device_response = {
            'body' => [
                {
                    'device_token' => '12341234',
                    'marked_inactive_on' => '2015-08-01',
                    'alias' => 'bob'
                },
                {
                    'device_token' => '43214321',
                    'marked_inactive_on' => '2015-08-03',
                    'alias' => 'alice'
                },
            ],
            'code' => '200'
        }

        allow(airship).to receive(:send_request).and_return(device_response)
        since = (Time.new.utc - 60 * 70 * 24 * 3).iso8601 # Get tokens deactivated since 3 days ago
        response = feedback.device_token(since)
        expect(response).to eq device_response  
      end
    end

    describe '#apid' do
      it 'can get the apids' do
        device_response = {
            'body' => [
                {
                    'apid' => '12341234',
                    'gcm_registration_id' => nil,
                    'marked_inactive_on' => '2015-08-01',
                    'alias' => 'bob'
                },
                {
                    'apid' => '43214321',
                    'gcm_registration_id' => nil,
                    'marked_inactive_on' => '2015-08-03',
                    'alias' => 'alice'
                },
            ],
            'code' => '200'
        }
        allow(airship).to receive(:send_request).and_return(device_response)
        since = (Time.new.utc - 60 * 70 * 24 * 3).iso8601 # Get apids deactivated since 3 days ago
        response = feedback.apid(since)
        expect(response).to eq device_response
      end
    end
  end
end