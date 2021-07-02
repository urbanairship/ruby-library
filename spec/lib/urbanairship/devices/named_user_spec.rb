require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')
  let(:channel_id) { '123' }
  let(:device_type) { 'android' }
  let(:named_user_id) { 'user' }

  named_user = nil

  describe Urbanairship::Devices::NamedUser do
    let(:expected_response) do
      {
        body: {
          ok: true
        },
        code: 200,
      }
    end

    before(:each) do
      named_user = UA::NamedUser.new(client: airship)
      named_user.named_user_id = named_user_id
    end

    describe '#associate' do
      describe 'Request' do
        after(:each) { named_user.associate(channel_id: channel_id, device_type: device_type) }

        it 'makes the expected request' do
          allow(airship).to receive(:send_request) do |arguments|
            expect(arguments).to eq(
              method: 'POST',
              body: { channel_id: channel_id, device_type: device_type, named_user_id: named_user_id }.to_json,
              path: "/named_users/associate",
              content_type: "application/json",
            )
            expected_response
          end
        end

        context 'Named user ID is an integer' do
          let(:named_user_id) { 1985 }

          it 'converts named user ID to a string' do
            allow(airship).to receive(:send_request) do |arguments|
              expect(JSON.parse(arguments[:body], symbolize_names: true)[:named_user_id]).to eq named_user_id.to_s
              expected_response
            end
          end
        end
      end

      it 'associates a channel with a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_resp = named_user.associate(channel_id:'123', device_type:'android')
        expect(actual_resp).to eq(expected_response)
      end

      it 'associates a web channel with a named_user without a device_type' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_resp = named_user.associate(channel_id:'123')
        expect(actual_resp).to eq(expected_response)
      end

      it 'fails when the user_id is not set' do
        named_user_without_id = UA::NamedUser.new(client: airship)
        expect {
          named_user_without_id.associate(channel_id:'123', device_type:'android')
        }.to raise_error(ArgumentError)
      end
    end

    describe '#disassociate' do
      it 'disassociates a channel from a named_user' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_resp = named_user.disassociate(channel_id:'123', device_type:'android')
        expect(actual_resp).to eq(expected_response)
      end

      it 'disassociates a web channel from a named_user without a device_type' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_resp = named_user.disassociate(channel_id:'123')
        expect(actual_resp).to eq(expected_response)
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

  describe Urbanairship::NamedUserList do
    named_user_item = {
      'named_user_id' => 'id',
      'tags' => { 'crm' => ['tag1', 'tag2' ] },
      'channels' => [
        {
          'channel_id' => 'id',
          'device_type' => 'ios',
          'installed' => true,
          'opt_in' => true,
          'push_address' => 'FFFF',
          'created' => '2015-08-01',
          'last_registeration' => '2015-08-01',
          'alias' => 'xxxx',
          'tags' => ['tag1'],
          'ios' => {
            'badge' => 0,
            'quiettime' => { 'start' => '22:00', 'end' => '06:00' },
            'tz' => 'America/Los_Angeles'
          }
        }
      ]
    }
    expected_response = {
      'body' => {
        'named_users' => [named_user_item, named_user_item, named_user_item ],
        'next_page' => 'url'
      },
      'code' => 200
    }
    expected_next_resp = {
      'body' => {
        'named_users' => [named_user_item, named_user_item, named_user_item ],
      },
      'code' => 200
    }

    it 'iterates correctly through a response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_next_resp)
      named_user_list = UA::NamedUserList.new(client:airship)
      instantiated_list = Array.new
      named_user_list.each do |named_user|
        expect(named_user).to eq(named_user_item)
        instantiated_list.push(named_user)
      end
      expect(instantiated_list.size).to eq(6)
    end
  end

  describe Urbanairship::Devices::NamedUserUninstaller do
    let(:expected_response) do
      {
        'body' => {
          'ok' => true
        },
        'code' => 200
      }
    end
    let(:named_user_uninstaller) { described_class.new(client: airship) }
    subject { named_user_uninstaller.uninstall }

    describe '#uninstall' do
      before do
        named_user_uninstaller.named_user_ids = ['user']
        allow(airship).to receive(:send_request).and_return(expected_response)
      end

      it 'uninstall named_users' do
        expect(subject).to eq(expected_response)
      end
    end
  end
end
