require 'spec_helper'

require 'urbanairship'
require 'urbanairship/client'
require 'urbanairship/devices/segment'


describe Urbanairship::Devices do

  describe Urbanairship::Devices::Segment do
    UA = Urbanairship
    test_name = 'Test Segment'
    test_criteria = {
      'and' => [
        {'tag' => 'TEST'},
        {'not' => {'tag' => 'TEST2'}}
      ]
    }
    data = {
      'name' => test_name,
      'criteria' => test_criteria
    }

    example_hash_create = {
      "body" => "",
      "code" => "200",
      "headers" => {:location => "https://go.urbanairship.com/api/segments/1234"}
    }
    example_hash_lookup = {
      "body" => data,
      "code" => "200"
    }
    example_hash_update = { "body" => {"ok"=>"true"}, "code" => "200"}
    example_hash_delete = { "body" => {"ok"=>"true"}, "code" => "204"}

    airship = UA::Client.new(key: '123', secret: 'abc')
    seg = UA::Segment.new
    seg.display_name = test_name
    seg.criteria = test_criteria

    describe '#create' do
      it 'can be invoked and parse 200 success' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_create)
        create_res = seg.create(airship)
        expect(create_res['code']).to eq "200"
      end
    end

    describe '#from_id' do
      it 'can lookup a segment from an id' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_lookup)

        lookup_res = seg.from_id(airship, 'test_id')
        expect(lookup_res['code']).to eq "200"
        expect(lookup_res['body']).to eq data
      end
    end

    describe '#update' do
      it 'can update a segment' do
        seg.display_name = "new_test_name"
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_update)

        update_res = seg.update(airship)
        expect(update_res['code']).to eq "200"
      end
    end

    describe '#delete' do
      it 'can delete a segment' do
        allow(airship)
          .to receive(:send_request)
          .and_return(example_hash_delete)

        delete_res = seg.delete(airship)
        expect(delete_res['code']).to eq "204"
      end
    end
  end
end
