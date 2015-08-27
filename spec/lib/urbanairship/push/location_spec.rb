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
    end
  end
end
