require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Common do
  it 'has a PUSH_URL' do
    expect(Urbanairship.push_url).not_to be nil
  end

  it 'has a SEGMENTS_URL' do
    expect(Urbanairship.segments_url).not_to be nil
  end

  it 'has a CHANNEL_URL' do
    expect(Urbanairship.channel_url).not_to be nil
  end

  describe Urbanairship::Common::PageIterator do
    let(:my_iterator_class) do
      Class.new(Urbanairship::Common::PageIterator) do
        def initialize(client: required('client'), data_attr:, next_page: nil, next_page_path: nil)
          super(client: client)

          @data_attribute = data_attr
          @next_page = next_page
          @next_page_path = next_page_path
        end
      end
    end
    let(:client) { Urbanairship::Client.new(key: '123', secret: 'abc') }
    let(:data_attr) { 'data_attr' }
    let(:second_url) { "https://#{Urbanairship.configuration.server}/api/page-1" }
    let(:first_response) do
      {
        'body' => {
          'data_attr' => [data_attr_1, data_attr_2],
          'next_page' => second_url
        },
        'code' => 200
      }
    end
    let(:second_response) do
      {
        'body' => {
          'data_attr' => [data_attr_3]
        },
        'code' => 200
      }
    end
    let(:data_attr_1) do
      {
        'prop1' => 'propertyA',
        'prop2' => 'propertyB',
        'prop3' => 'propertyC'
      }
    end
    let(:data_attr_2) do
      {
        'prop1' => 'propertyD',
        'prop2' => 'propertyE',
        'prop3' => 'propertyF'
      }
    end
    let(:data_attr_3) do
      {
        'prop1' => 'propertyG',
        'prop2' => 'propertyH',
        'prop3' => 'propertyI'
      }
    end

    context 'with @next_page defined' do
      let(:my_iterator) do
        my_iterator_class.new(client: client, data_attr: data_attr, next_page: first_url)
      end
      let(:first_url) { "https://#{Urbanairship.configuration.server}/api/page-0" }

      it 'iterates through pages' do
        allow(client)
          .to receive(:send_request)
            .with({ method: 'GET', url: first_url })
              .and_return(first_response)
        allow(client)
          .to receive(:send_request)
            .with({ method: 'GET', url: second_url })
              .and_return(second_response)

        finished_list = []
        my_iterator.each { |value| finished_list.push(value) }

        expect(finished_list).to eq([data_attr_1, data_attr_2, data_attr_3])
        expect(my_iterator.count).to eq(3)
      end
    end
  end
end
