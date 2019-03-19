require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/email'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::Email do
    register_response = {
      "ok": true,
      "channel_id": "251d3318-b3cb-4e9f-876a-ea3bfa6e47bd"
    }

    email_success_resp = {
      'body' => {
        'ok' => true,
      },
      'code'=> 200
    }

    describe '#register' do
      it 'can register email channel' do
        email_channel = UA::Email.new(client: airship)
        email_channel.type = 'email'
        email_channel.commercial_opted_in = '2018-10-28T10:34:22'
        email_channel.address = 'finnthehuman@adventure.com'
        email_channel.timezone = 'America/Los_Angeles'
        email_channel.locale_country = 'US'
        email_channel.locale_language = 'en'

        allow(airship).to receive(:send_request).and_return(register_response)
        actual_resp = email_channel.register
        expect(actual_resp).to eq(register_response)
      end

      it 'fails when address is not set' do
        email_channel = UA::Email.new(client: airship)
        email_channel.type = 'email'
        email_channel.commercial_opted_in = '2018-10-28T10:34:22'
        email_channel.timezone = 'America/Los_Angeles'
        email_channel.locale_country = 'US'
        email_channel.locale_language = 'en'

        expect{email_channel.register()}.to raise_error(ArgumentError)
      end
    end
  end

  describe Urbanairship::EmailTags do
    email_list = %w(finnthehuman@adventure.com jakethedog@adventure.com lumpyspaceprincess@adventure.com)
    let(:email_tags) { UA::EmailTags.new(client: airship) }

    describe '#set_audience' do
      it 'can set the audience successfully' do
        email_tags.set_audience(email_address: email_list)
        expect(email_tags.audience['email_address']) .to eq(email_list)
      end
    end

    describe '#add' do
      it 'adds a group correctly' do
        email_tags.add(group_name: :group_name, tags: :tag1)
        expect(email_tags.add_group[:group_name]).to eq :tag1
      end
    end

    describe '#remove' do
      it 'removes a group correctly' do
        email_tags.remove(group_name: :group_name, tags: :tag1)
        expect(email_tags.remove_group[:group_name]).to eq :tag1
      end
    end

    describe '#set' do
      it 'sets a group correctly' do
        email_tags.set(group_name: :group_name, tags: :tag1)
        expect(email_tags.set_group[:group_name]).to eq :tag1
      end
    end

    it 'add and removes a group correctly simultaneously' do
      email_tags.add(group_name: :group_name, tags: :tag1)
      email_tags.remove(group_name: :group_name, tags: :tag2)
      expect(email_tags.add_group[:group_name]).to eq :tag1
      expect(email_tags.remove_group[:group_name]).to eq :tag2
    end

    describe '#send_request' do
      it 'fails when add and set are used simultaneously' do
        email_tags.add(group_name: :group_name, tags: :tag1)
        email_tags.set(group_name: :group_name, tags: :tag1)
        expect {
          email_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove and set are used simultaneously' do
        email_tags.remove(group_name: :group_name, tags: :tag1)
        email_tags.set(group_name: :group_name, tags: :tag1)
        expect {
          email_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove, add, and set are not set' do
        email_tags.set_audience(email_address: :email_address)
        expect {
          email_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when audience is not set' do
        email_tags.add(group_name: :group_name, tags: :tag1)
        expect {
          email_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'sends a request correctly' do
        mock_response = {
          'body' => {
            'ok' => true
          },
          'code' => 200
        }
        email_tags.set_audience(email_address: :email_address)
        email_tags.add(group_name: :group_name, tags: :tag1)
        allow(airship)
            .to receive(:send_request).and_return(mock_response)
        response = email_tags.send_request
        expect(response).to eq(mock_response)
      end
    end
  end

end
