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
        'next_page' => 'next_url2'
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

  describe Urbanairship::Devices::DeviceToken do
    device_token = UA::DeviceToken.new(client: airship)

    describe '#lookup' do
      it 'fails when given a non-string token' do
        expect {
          device_token.lookup(token: 123)
        }.to raise_error(ArgumentError)
      end

      it 'returns info on a device token correctly' do
        expected_resp = {
          'body' => {
            'device_token' => 'device token',
            'active' => true,
            'alias' => 'alias',
            'tags' => ['tag1', 'tag2'],
            'created' => '2015-08-01',
            'last_registration' => '2015-08-01',
            'badge' => 2,
            'quiettime' => {
              'start' => '22:00',
              'end' => '8:00'
            },
            'tz' => "America/Los_Angeles"
          } ,
          'code' => 200
        }
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = device_token.lookup(token: 'token')
        expect(actual_resp).to eq(expected_resp)
      end
    end
  end

  describe Urbanairship::Devices::DeviceTokenList do
    token = {
      'device_token' => 'device token',
      'active' => true,
      'alias' => 'alias',
      'tags' => ['tag1', 'tag2'],
      'created' => '2015-08-01',
      'last_registration' => '2015-08-01',
      'badge' => 2,
      'quiettime' => {
        'start' => '22:00',
        'end' => '8:00'
      },
      'tz' => "America/Los_Angeles"
    }
    expected_resp = {
      'body' => {
        'device_tokens' => [token, token, token],
        'device_tokens_count' => 3,
        'next_page' => 'url'
      },
      'code' => 200
    }
    expected_next_response = {
      'body' => {
        'device_tokens' => [token, token, token],
        'device_tokens_count' => 3
      },
      'code' => 200
    }
    it 'can iterate through a list correctly' do
      allow(airship).to receive(:send_request).and_return(expected_resp, expected_next_response)
      device_token_list = UA::DeviceTokenList.new(client: airship)
      instantiated_list = Array.new
      device_token_list.each do |t|
        instantiated_list.push(t)
        expect(token).to eq(t)
      end
      expect(instantiated_list.size).to eq(6)
    end
  end

  describe Urbanairship::Devices::APID do
    expected_resp = {
      'body' => {
        'apid' => 'apid',
        'active' => true,
        'alias' => 'alias',
        'tags' => ['tag1', 'tag2'],
        'created' => '2015-08-01',
        'last_registration' => '2015-08-01',
        'gcm_registration_id' => 'id'
      },
      'code' => 200
    }
    apid = UA::APID.new(client: airship)

    it 'fails if apid is not a string' do
      expect {
        apid.lookup(123)
      }.to raise_error(ArgumentError)
    end

    it 'returns apid info correctly' do
      allow(airship).to receive(:send_request).and_return(expected_resp)
      actual_response = apid.lookup(apid: 'apid')
      expect(actual_response).to eq(expected_resp)
    end
  end

  describe Urbanairship::Devices::APIDList do
    apid = {
      'apid' => 'apid',
      'active' => true,
      'alias' => 'alias',
      'tags' => ['tag1', 'tag2'],
      'created' => '2015-08-01',
      'last_registration' => '2015-08-01',
      'gcm_registration_id' => 'id'
    }
    expected_resp = {
      'body' => {
        'apids' => [apid, apid, apid],
        'next_page' => 'url'
      },
      'code' => 200
    }
    expected_next_resp = {
      'body' => {
        'apids' => [apid, apid, apid],
      },
      'code' => 200
    }

    it 'correctly iterates over the list' do
      allow(airship).to receive(:send_request).and_return(expected_resp, expected_next_resp)
      apid_list = Urbanairship::APIDList.new(client: airship)
      instantiated_list = Array.new
      apid_list.each do |a|
        instantiated_list.push(a)
        expect(a).to eq(apid)
      end
      expect(instantiated_list.size).to eq(6)
    end
  end
end