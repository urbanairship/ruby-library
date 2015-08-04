require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Common do
  it 'has a PUSH_URL' do
    expect(Urbanairship::Common::PUSH_URL).not_to be nil
  end

  describe Urbanairship::Common::PageIterator do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')
    page_iterator = UA::Common::PageIterator.new(airship)
    page_iterator.data_attribute = :data_attr
    expected_first_list = {
      'body' => {
        :data_attr => [
          {
            :prop1 => 'propertyA',
            :prop2 => 'propertyB',
            :prop3 => 'propertyC'
          },
          {
            :prop1 => 'propertyD',
            :prop2 => 'propertyE',
            :prop3 => 'propertyF'
          }
        ],
        'next_page' => 'next_url'
      },
      'code' => 200
    }

    expected_second_list = {
        'body' => {
          :data_attr => [
            {
              :prop1 => 'propertyG',
              :prop2 => 'propertyH',
              :prop3 => 'propertyI'
            }
          ]
        },
        'code' => 200
    }
    it 'can iterate through pages' do
      allow(airship).to receive(:send_request).and_return(expected_first_list, expected_second_list)
      finished_list = Array.new
      page_iterator.load_page

      page_iterator.each do |value|
        finished_list.push(value)
      end

      obj_list = %w(propertyI propertyH propertyG propertyF propertyE propertyD propertyC propertyB propertyA)

      finished_list.each do |value|
        expect(value[:prop1]).to eq(obj_list.pop)
        expect(value[:prop2]).to eq(obj_list.pop)
        expect(value[:prop3]).to eq(obj_list.pop)
      end

    end
  end
end
