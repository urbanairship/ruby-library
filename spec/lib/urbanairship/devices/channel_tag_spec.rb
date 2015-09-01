require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Devices do
  describe Urbanairship::Devices::ChannelTags do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    let(:channel_tags) { UA::ChannelTags.new(client: airship) }
    describe '#set_audience' do
      it 'sets an ios audience correctly' do
        channel_tags.set_audience(ios: :ios_audience)
        expect(channel_tags.audience['ios_channel']).to eq :ios_audience
      end

      it 'sets an android audience correctly' do
        channel_tags.set_audience(android: :android_audience)
        expect(channel_tags.audience['android_channel']).to eq :android_audience
      end

      it 'sets an amazon audience correctly' do
        channel_tags.set_audience(amazon: :amazon_audience)
        expect(channel_tags.audience['amazon_channel']).to eq :amazon_audience
      end

      it 'sets all audiences correct simultaneously' do
        channel_tags.set_audience(ios: :ios_audience, android: :android_audience,
                                  amazon: :amazon_audience)
        expect(channel_tags.audience['ios_channel']).to eq :ios_audience
        expect(channel_tags.audience['android_channel']).to eq :android_audience
        expect(channel_tags.audience['amazon_channel']).to eq :amazon_audience
      end
    end

    describe '#add' do
      it 'adds a group correctly' do
        channel_tags.add(group_name: :group_name, tags: :tag1)
        expect(channel_tags.add_group[:group_name]).to eq :tag1
      end
    end

    describe '#remove' do
      it 'removes a group correctly' do
        channel_tags.remove(group_name: :group_name, tags: :tag1)
        expect(channel_tags.remove_group[:group_name]).to eq :tag1
      end
    end

    describe '#set' do
      it 'sets a group correctly' do
        channel_tags.set(group_name: :group_name, tags: :tag1)
        expect(channel_tags.set_group[:group_name]).to eq :tag1
      end
    end

    it 'add and removes a group correctly simultaneously' do
      channel_tags.add(group_name: :group_name, tags: :tag1)
      channel_tags.remove(group_name: :group_name, tags: :tag2)
      expect(channel_tags.add_group[:group_name]).to eq :tag1
      expect(channel_tags.remove_group[:group_name]).to eq :tag2
    end

    describe '#send_request' do
      it 'fails when add and set are used simultaneously' do
        channel_tags.add(group_name: :group_name, tags: :tag1)
        channel_tags.set(group_name: :group_name, tags: :tag1)
        expect {
          channel_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove and set are used simultaneously' do
        channel_tags.remove(group_name: :group_name, tags: :tag1)
        channel_tags.set(group_name: :group_name,tags: :tag1)
        expect {
          channel_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when remove, add, or set are not set' do
        channel_tags.set_audience(ios: :ios_audience)
        expect {
          channel_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'fails when audience is not set' do
        channel_tags.add(group_name: :group_name, tags: :tag1)
        expect {
          channel_tags.send_request
        }.to raise_error(ArgumentError)
      end

      it 'sends a request correctly' do
        mock_response = {
            'body' => {
                'ok' => true
            },
            'code' => 200
        }
        channel_tags.set_audience(ios: :ios_audience)
        channel_tags.add(group_name: :group_name, tags: :tag1)
        allow(airship)
            .to receive(:send_request).and_return(mock_response)
        response = channel_tags.send_request
        expect(response).to eq(mock_response)
      end
    end
  end
end
