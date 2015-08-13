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
    named_user = UA::NamedUser.new(client: airship, named_user_id: 'user_id')

    describe '#associate' do
      it 'associates a channel with a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = named_user.associate(channel_id:'123', device_type:'android')
        expect(actual_resp).to eq(expected_resp)
      end

      it 'fails when the user_id is not set' do
        named_user_without_id = UA::NamedUser.new(client: airship)
        expect {
          named_user_without_id.associate(channel_id:'123', device_type:'android')
        }.to raise_error(ArgumentError)
      end
    end

    describe '#disassociate' do
      it 'disassociates a channel with a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = named_user.disassociate(channel_id:'123', device_type:'android')
        expect(actual_resp).to eq(expected_resp)
      end
    end

    describe '#lookup' do
      it 'can look up a named_user' do
        expected_lookup_resp = {
          'body' => {
            'ok' => true,
            'named_user' => {
              'named_user_id' => 'user-id-1234',
              'tags' => {
                'crm' => %w(tag1 tag2)
              },
              'channels' => [
                {
                  'channel_id' => 'ABCD',
                  'device_type' => 'ios',
                  'installed' => true,
                  'opt_in' => true,
                  'push_address' => 'FFFF',
                  'created' => '2013-08-08T20:41:06',
                  'last_registration' => '2014-05-01T18:00:27',
                  'alias' => 'xxxx',
                  'ios' => {
                    'badge' => 0,
                    'quiettime' => {
                      'start' => '22:00',
                      'end' => '06:00'
                    },
                    'tz' => 'America/Los_Angeles'
                  }
                }
              ]
            }
          },
          'code' => 200
        }
        allow(airship).to receive(:send_request).and_return(expected_lookup_resp)
        actual_resp = named_user.lookup
        expect(actual_resp).to eq(expected_lookup_resp)
      end

      it 'fails when the user_id is not set' do
        named_user_without_id = UA::NamedUser.new(client: airship)
        expect {
          named_user_without_id.lookup
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe Urbanairship::NamedUserTags do
    named_user_list = %w(user1 user2 user3)
    let(:named_user_tags) { UA::NamedUserTags.new(client: airship) }

    describe '#set_audience' do
      it 'can set the audience successfully' do
        named_user_tags.set_audience(user_ids: named_user_list)
        expect(named_user_tags.audience['named_user_id']) .to eq(named_user_list)
      end
    end

    describe '#add' do
      it 'adds a group correctly' do
        named_user_tags.add(group_name: :group_name, tags: :tag1)
        expect(named_user_tags.add_group[:group_name]).to eq :tag1
      end
    end

    describe '#remove' do
      it 'removes a group correctly' do
        named_user_tags.remove(group_name: :group_name, tags: :tag1)
        expect(named_user_tags.remove_group[:group_name]).to eq :tag1
      end
    end

    describe '#set' do
      it 'sets a group correctly' do
        named_user_tags.set(group_name: :group_name, tags: :tag1)
        expect(named_user_tags.set_group[:group_name]).to eq :tag1
      end
    end

    it 'add and removes a group correctly simultaneously' do
      named_user_tags.add(group_name: :group_name, tags: :tag1)
      named_user_tags.remove(group_name: :group_name, tags: :tag2)
      expect(named_user_tags.add_group[:group_name]).to eq :tag1
      expect(named_user_tags.remove_group[:group_name]).to eq :tag2
    end

    describe '#send_request' do
      it 'fails when add and set are used simultaneously' do
        named_user_tags.add(group_name: :group_name, tags: :tag1)
        named_user_tags.set(group_name: :group_name, tags: :tag1)
        expect {
          named_user_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove and set are used simultaneously' do
        named_user_tags.remove(group_name: :group_name, tags: :tag1)
        named_user_tags.set(group_name: :group_name, tags: :tag1)
        expect {
          named_user_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove, add, and set are not set' do
        named_user_tags.set_audience(user_ids: :user_ids)
        expect {
          named_user_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when audience is not set' do
        named_user_tags.add(group_name: :group_name, tags: :tag1)
        expect {
          named_user_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'sends a request correctly' do
        mock_response = {
          'body' => {
            'ok' => true
          },
          'code' => 200
        }
        named_user_tags.set_audience(user_ids: :user_ids)
        named_user_tags.add(group_name: :group_name, tags: :tag1)
        allow(airship)
            .to receive(:send_request).and_return(mock_response)
        response = named_user_tags.send_request
        expect(response).to eq(mock_response)
      end
    end
  end
end