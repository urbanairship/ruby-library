require 'spec_helper'

require 'urbanairship'
require 'urbanairship/client'
require 'urbanairship/devices/segment'

describe Urbanairship::Devices do
  describe Urbanairship::Devices::Segment do
    test_name = 'Test Segment'
    test_criteria = {
      'and' => [
        {'tag' => 'TEST'},
        {'not' => {'tag' => 'TEST2'}}
      ]
    }
    data = {
      'display_name' => test_name,
      'criteria' => test_criteria
    }

    example_hash_create = {
      'body' => '',
      'code' => '200',
      'headers' => {:location => "https://go.urbanairship.com/api/segments/1234"}
    }
    example_hash_lookup = {
      'body' => data,
      'code' => '200'
    }
    example_hash_update = { 'body' => '', 'code' => '200'}
    example_hash_delete = { 'body' => '', 'code' => '204'}

    airship = UA::Client.new(key: '123', secret: 'abc')
    seg = UA::Segment.new(client: airship)
    seg.display_name = test_name
    seg.criteria = test_criteria

    describe '#create' do
      it 'can be invoked and parse 200 value' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_create)

        create_res = seg.create
        expect(create_res['code']).to eq '200'
      end
    end

    describe '#from_id' do
      it 'can be invoked and parse 200 value' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_lookup)

        lookup_res = seg.from_id(id: 'test_id')
        expect(lookup_res['code']).to eq '200'
        expect(lookup_res['body']).to eq data
      end
    end

    describe '#update' do
      it 'can be invoked and parse 200 return value' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_update)

        seg.display_name = 'New Test Segment'
        update_res = seg.update
        expect(update_res['code']).to eq '200'
      end
    end

    describe '#delete' do
      it 'can be invoked and parse a 204 return value' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_delete)

        delete_res = seg.delete
        expect(delete_res['code']).to eq '204'
      end
    end
  end

  describe Urbanairship::Devices::SegmentList do
    example_hash_list = {
      'body' => {
        'segments' => [
          { 'display_name' => 'test1' },
          { 'display_name' => 'test2' }
        ]
      },
      'code' => 200
    }
    let(:seglist_http_response) { example_hash_list }
    name_list = ['test2', 'test1']

    it 'can be invoked and iterate through values' do
      airship = UA::Client.new(key: '123', secret: 'abc')
      response =
      allow(airship)
        .to receive(:send_request)
        .and_return(seglist_http_response)

      seglist = UA::SegmentList.new(client: airship)
      seglist.each do |seg|
        expect(seg['display_name']).to eq name_list.pop
      end
    end
  end
end
