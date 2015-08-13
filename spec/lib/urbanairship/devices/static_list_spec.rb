require 'spec_helper'
require 'urbanairship'
require 'csv'


describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: 123, secret: 'abc')

  describe Urbanairship::Devices::StaticList do
    static_list = UA::StaticList.new(client: airship, name: 'test_list')

    expected_response = {
      :ok => true
    }

    it 'will fail when name is set to nil' do
      expect {
        UA::StaticList.new(client: airship, name: nil)
      }.to raise_error(ArgumentError)
    end

    it 'will fail when client is set to nil' do
      expect {
        UA::StaticList.new(client: nil, name: 'test_list')
      }.to raise_error(ArgumentError)
    end

    describe '#create' do
      it 'can create a list successfully without parameters' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.create
        expect(actual_response).to eq(expected_response)
      end

      it 'can create a list successfully with parameters set' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.create(description: 'this description', extras: {:key => 'value'})
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#upload' do
      CSV.open('csv_file', 'wb') do |csv|
        csv << %w(alias stevenh)
        csv << %w(alias marianb)
        csv << %w(named_user billg)
      end

      it 'can upload a csv file successfully' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.upload(csv_file: 'csv_file')
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#update' do
      it 'can update the description of a static list successfully' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.update(description: 'new description')
        expect(actual_response).to eq(expected_response)
      end

      it 'can update the extras of a static list successfully' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.update(extras: { 'key' => 'value'})
        expect(actual_response).to eq(expected_response)
      end

      it 'will fail if neither description nor extras is not included' do
        expect {
          static_list.update
        }.to raise_error(ArgumentError)
      end
    end

    describe '#lookup' do
      expected_response = {
        'body' => {
          'ok' => true,
          'name' => 'test_list',
          'description' => 'loyalty program platinum members',
          'extra' => {'key' => 'value'},
          'created' => '2013-08-08T20:41:06',
          'last_updated' => '2014-05-01T18:00:27',
          'channel_count' => 1000,
          'status' => 'ready'
        },
        'code' => 200
      }

      it 'can retrieve static list information successfully' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.lookup
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#delete' do
      expected_response = {
        'body' => {},
        'code' => 204
      }

      it 'can delete a static list successfully' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = static_list.delete
        expect(actual_response).to eq(expected_response)
      end
    end
  end

  describe Urbanairship::Devices::StaticLists do
    item = {
      'name' => 'ca-testlist',
      'description' => 'this little list',
      'extras' => {'key' => 'value'},
      'created' => '2015-06-29T23:42:39',
      'last_updated' => '2015-06-30T23:42:39',
      'channel_count' => 123,
      'status' => 'ready'
    }
    expected_response = {
      'body' => {
        'lists' => [ item, item, item ],
        'next_page' => 'next_url'
      },
      'code' => 200
    }
    expected_next_response = {
      'body' => {
        'lists' => [ item, item, item ],
      },
      'code' => 200
    }


    it 'can return a list of static lists successfully' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_next_response)
      static_lists = UA::StaticLists.new(client: airship)

      instantiated_lists = Array.new
      static_lists.each do |static_list|
        instantiated_lists.push(static_list)
        expect(static_list).to eq(item)
      end
      expect(instantiated_lists.count).to eq(6)
    end
  end
end