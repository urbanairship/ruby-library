require 'spec_helper'
require 'urbanairship'
require 'urbanairship/ab_tests/variant'

describe Urbanairship::AbTests do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::AbTests::Variant do
        
        variant_payload = {
             'description': 'description of this variant',
             'id': '0',
             'name': 'variant one',
             'push': {
                        "notification": {
                            "alert": "message 1"
                        }
                    },
             'schedule': {
                            "scheduled_time": "2018-04-01T18:45:30"
                            },
             'weight': '2'   
            }

        describe '#payload' do 
            it 'correctly formats payload for variant' do
                variant = UA::Variant.new(client: airship)
                variant.description = 'description of this variant'
                variant.id = '0'
                variant.name = 'variant one'
                variant.push = {
                                    "notification": {
                                        "alert": "message 1"
                                    }
                                }
                variant.schedule = {
                                    "scheduled_time": "2018-04-01T18:45:30"
                                    }
                variant.weight = '2'
                expect(variant.payload).to eq(variant_payload)
            end

            it 'fails when push is not included' do 
                variant = UA::Variant.new(client: airship)
                variant.description = 'description of this variant'
                variant.id = '0'
                variant.name = 'variant one'
                variant.schedule = {
                                    "scheduled_time": "2018-04-01T18:45:30"
                                    }
                variant.weight = '2'
                expect{variant.payload}.to raise_error(ArgumentError)
            end
        end
    end
end