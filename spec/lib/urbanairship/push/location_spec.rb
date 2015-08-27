require 'spec_helper'
require 'urbanairship'


describe Urbanairship do
  describe Urbanairship::Push do
    describe Urbanairship::Push::Location do
      UA = Urbanairship
      airship = UA::Client.new(key: '123', secret: 'abc')
      location = UA::Location.new(client: airship)
      expected_resp = {
        "features" => [
          {
            "bounds" => [
              37.63983,
              -123.173825,
              37.929824,
              -122.28178
            ],
            "centroid" => [
              37.759715,
              -122.693976
            ],
            "id" => "4oFkxX7RcUdirjtaenEQIV",
            "properties" => {
              "boundary_type" => "city",
              "boundary_type_string" => "City/Place",
              "context" => {
                "us_state" => "CA",
                "us_state_name" => "California"
              },
              "name" => "San Francisco",
              "source" => "tiger.census.gov"
            },
            "type" => "Feature"
          }
        ]
      }
      describe '#name_lookup' do
        it 'fails if name is not a string' do
          expect {
            location.name_lookup(name: 123)
          }.to raise_error(ArgumentError)
        end

        it 'fails when type is not a string' do
          expect {
            location.name_lookup(name: 'name', type: 123)
          }.to raise_error(ArgumentError)
        end

        it 'returns location by name successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.name_lookup(name: 'name')
          expect(actual_resp).to eq(expected_resp)
        end
      end

      describe '#coordinates_lookup' do
        it 'fails if latitude is a string' do
          expect {
            location.coordinates_lookup(latitude: 'bad value', longitude: 123)
          }.to raise_error(ArgumentError)
        end

        it 'fails if longitue is a string' do
          expect {
            location.coordinates_lookup(latitude: 123, longitude: 'bad value')
          }.to raise_error(ArgumentError)
        end

        it 'fails if type is not a string' do
          expect {
            location.coordinates_lookup(latitude: 123, longitude: 'bad value', type: 123)
          }.to raise_error(ArgumentError)
        end

        it 'returns location by coordinates successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.coordinates_lookup(latitude: 123, longitude: 123)
          expect(actual_resp).to eq(expected_resp)
        end
      end

      describe '#bounding_box_lookup' do
        it 'fails if the bounds are a string' do
          expect {
            location.bounding_box_lookup(lat1: 'bad value', long1: 'bad value',
                                         lat2: 'bad value', long2: 'bad value')
          }.to raise_error(ArgumentError)
        end

        it 'fails if type is not a string' do
          expect {
            location.coordinates_lookup(lat1: 'bad value', long1: 'bad value',
                                        lat2: 'bad value', long2: 'bad value',
                                        type: 123)
          }.to raise_error(ArgumentError)
        end

        it 'returns location by bounding box successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.bounding_box_lookup(lat1: 123, long1: 123,
                                                    lat2: 123, long2: 123,
                                                    type: 'type')
          expect(actual_resp).to eq(expected_resp)
        end
      end

      describe '#alias_lookup' do
        it 'fails if alias is not a string' do
          expect {
            location.alias_lookup(from_alias: 123)
          }.to raise_error(ArgumentError)
        end

        it 'returns location by alias successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.alias_lookup(from_alias: 'alias=alias')
          expect(actual_resp).to eq(expected_resp)
        end

        it 'returns location by array of aliases successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.alias_lookup(from_alias: ['alias=alias', 'alias=alias'])
          expect(actual_resp).to eq(expected_resp)
        end
      end

      describe '#polygon_lookup' do
        it 'fails if polygon_id is not a string' do
          expect {
            location.polygon_lookup(polygon_id: 123, zoom: 1)
          }.to raise_error(ArgumentError)
        end

        it 'fails if zoom is not a number' do
          expect {
            location.polygon_lookup(polygon_id: 'id', zoom: 'bad value')
          }.to raise_error(ArgumentError)
        end

        it 'returns location by polygon successfully' do
          allow(airship).to receive(:send_request).and_return(expected_resp)
          actual_resp = location.polygon_lookup(polygon_id: 'id', zoom: 1)
          expect(actual_resp).to eq(expected_resp)
        end
      end
    end
  end
end
