require 'spec_helper'
require 'urbanairship'
require 'urbanairship/ab_tests/variant'
require 'urbanairship/ab_tests/experiment'

describe Urbanairship::AbTests do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::AbTests::Experiment do

        experiment_payload = {
            'name': 'Neat experiment',
            'description': 'See how neat we can get',
            'control': '50',
            'audience': 'all',
            'device_types': 'all',
            'campaigns': {
                "categories": [
                    "kittens",
                    "tacos"
                ]
            },
            'variants': [{"push": {"notification": {"alert": "I love cereal"}}}, {"push": {"notification": {"alert": "I prefer oatmeal"}}}],
            'id': '12345',
            'created_at': '2018-04-01T18:45:30',
            'push_id': '67890'
        }

        describe '#payload' do 
            it 'correctly formats experiment with variant object' do
                variant_one = UA::Variant.new(client: airship)
                variant_one.push = {
                    "notification": {
                        "alert": "I love cereal"
                    }
                }
                variant_two = UA::Variant.new(client: airship)
                variant_two.push = {
                    "notification": {
                        "alert": "I prefer oatmeal"
                    }
                }
 
                experiment = UA::Experiment.new(client: airship)
                experiment.name = 'Neat experiment'
                experiment.description = 'See how neat we can get'
                experiment.control = '50'
                experiment.audience = 'all'
                experiment.device_types = 'all'
                experiment.campaigns = {
                    "categories": [
                        "kittens",
                        "tacos"
                    ]
                }
                experiment.variants << variant_one.payload
                experiment.variants << variant_two.payload 
                experiment.id = '12345'
                experiment.created_at = '2018-04-01T18:45:30'
                experiment.push_id = '67890'
                expect(experiment.payload).to eq(experiment_payload)
            end

            it 'fails when audience is not set' do
                variant_one = UA::Variant.new(client: airship)
                variant_one.push = {
                    "notification": {
                        "alert": "I love cereal"
                    }
                }
                variant_two = UA::Variant.new(client: airship)
                variant_two.push = {
                    "notification": {
                        "alert": "I prefer oatmeal"
                    }
                }
 
                experiment = UA::Experiment.new(client: airship)
                experiment.name = 'Neat experiment'
                experiment.description = 'See how neat we can get'
                experiment.control = '50'
                experiment.device_types = 'all'
                experiment.campaigns = {
                    "categories": [
                        "kittens",
                        "tacos"
                    ]
                }
                experiment.variants << variant_one.payload
                experiment.variants << variant_two.payload 
                experiment.id = '12345'
                experiment.created_at = '2018-04-01T18:45:30'
                experiment.push_id = '67890'
                expect{experiment.payload}.to raise_error(ArgumentError)
            end

            it 'fails when device type is not set' do 
                variant_one = UA::Variant.new(client: airship)
                variant_one.push = {
                    "notification": {
                        "alert": "I love cereal"
                    }
                }
                variant_two = UA::Variant.new(client: airship)
                variant_two.push = {
                    "notification": {
                        "alert": "I prefer oatmeal"
                    }
                }
 
                experiment = UA::Experiment.new(client: airship)
                experiment.name = 'Neat experiment'
                experiment.description = 'See how neat we can get'
                experiment.control = '50'
                experiment.device_types = 'all'
                experiment.campaigns = {
                    "categories": [
                        "kittens",
                        "tacos"
                    ]
                }
                experiment.variants << variant_one.payload
                experiment.variants << variant_two.payload 
                experiment.id = '12345'
                experiment.created_at = '2018-04-01T18:45:30'
                experiment.push_id = '67890'
                expect{experiment.payload}.to raise_error(ArgumentError)
            end

            it 'fails when variants is empty' do
                experiment = UA::Experiment.new(client: airship)
                experiment.name = 'Neat experiment'
                experiment.description = 'See how neat we can get'
                experiment.control = '50'
                experiment.audience = 'all'
                experiment.device_types = 'all'
                experiment.campaigns = {
                    "categories": [
                        "kittens",
                        "tacos"
                    ]
                }
                experiment.id = '12345'
                experiment.created_at = '2018-04-01T18:45:30'
                experiment.push_id = '67890'
                expect{experiment.payload}.to raise_error(ArgumentError)
            end
        end

    end

end