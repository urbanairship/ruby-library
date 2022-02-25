require 'spec_helper'
require 'urbanairship'
require 'csv'

UA = Urbanairship

describe Urbanairship::Devices do
  airship = UA::Client.new(key: 123, secret: 'abc')

  describe Urbanairship::Devices::TagList do
    tag_list = UA::TagList.new(client: airship)
    tag_list.name = 'test-list'
    expected_response = {
      :ok => true
    }

    it 'will fail when client is set to nil' do
      expect {
        UA::StaticList.new(client: nil)
      }.to raise_error(ArgumentError)
    end

    describe '#create' do
      it 'can create a list without parameters' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = tag_list.create
        expect(actual_response).to eq(expected_response)
      end

      it 'can create a list with parameters' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = tag_list.create(
          description: 'test desc',
          extra: { 'key': 'value' },
          add: { 'group_name': [ 'tag1', 'tag2' ] },
          remove: { 'group_name': [ 'tag1', 'tag2' ] },
          set: { 'group_name': [ 'tag1', 'tag2' ] }
        )
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#upload' do
      CSV.open('tags_csv_file', 'wb') do |csv|
        csv << %w(channel_id)
        csv << %w(3d25e414-736b-4473-82dd-064c5941f4a6)
      end
      it 'can upload a csv file' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = tag_list.upload(csv_file: 'tags_csv_file')
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#errors' do
      it 'can get a csv of upload errors' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = tag_list.errors
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#list' do
      it 'can get a single-page listing of tag lists' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = tag_list.list
        expect(actual_response).to eq(expected_response)
      end
    end
  end
end
