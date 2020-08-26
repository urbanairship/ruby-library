require 'spec_helper'
require 'urbanairship'
require 'urbanairship/ab_tests/variant'
require 'urbanairship/ab_tests/experiment'
require 'urbanairship/ab_tests/ab_test'

describe Urbanairship::AbTests do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::AbTests::AbTest do

        list_experiment_response =  {
            "ok": "true",
            "count": 2,
            "total_count": 2,
            "experiments": [{
                "name": "Experiment 1",
                "control": 0.33,
                "audience": "all",
                "device_types": [ "ios", "android" ],
                "variants": [{
                "push": {
                    "notification": {
                    "alert": "message 1"
                    }
                },
                "id": 0,
                },
                {
                "push": {
                    "notification": {
                        "alert": "message 2"
                    }
                },
                "id": 1,
                }],
                "id": "b5bc3dd1-9ea4-4208-b5f1-9e7ac3fe0502",
                "created_at": "2016-03-03T21:08:05",
                "push_id": "07cec298-6b8c-49f9-8e03-0448a06f4aac"
            }, 
            {
                "name": "Experiment 2",
                "description": "The second experiment",
                "audience": "all",
                "device_types": [ "ios", "android" ],
                "variants": [{
                "push": {
                    "notification": {
                    "alert": "message 1"
                    }
                },
                "id": 0,
                },
                {
                "push": {
                    "notification": {
                        "alert": "message 2"
                    }
                },
                "id": 1,
                }],
                "id": "e464aa7e-be40-4994-a290-1bbada7187d8",
                "created_at": "2016-03-03T21:08:05",
                "push_id": "07cec298-6b8c-49f9-8e03-0448a06f4aac"
            }]
        }

        create_ab_test_response = {
            "ok": "true",
            "operation_id": "03ca94a3-2b27-42f6-be7e-41efc2612cd4",
            "experiment_id": "0f7704e9-5dc0-4f7d-9964-e89055701b0a",
            "push_id": "7e13f060-594c-11e4-8ed6-0800200c9a66"
        }

        list_scheduled_response = {
            "ok": "true",
            "count": 2,
            "total_count": 2,
            "experiments": [
                {
                    "id": "0f7704e9-5dc0-4f7d-9964-e89055701b0a",
                    "name": "Experiment 1",
                    "audience": "all",
                    "device_types": [ "ios", "android" ],
                    "variants": [
                        {
                            "id": 0,
                            "schedule": {
                                "scheduled_time": "2015-11-17T20:58:00Z"
                            },
                            "push": {
                                "notification": {
                                    "alert": "message 1"
                                }
                            }
                        },
                        {
                            "id": 1,
                            "schedule": {
                                "scheduled_time": "2015-11-17T20:58:00Z"
                            },
                            "push": {
                                "notification": {
                                    "alert": "message 2"
                                }
                            }
                        }
                    ]
                }
            ]
        }

        delete_ab_test_response = {
            "ok": "true",
            "operation_id": "03ca94a3-2b27-42f6-be7e-41efc2612cd4"
        }

        lookup_ab_test_response =  {
            "ok": "true",
            "experiment": {
                "id": "0f7704e9-5dc0-4f7d-9964-e89055701b0a",
                "push_id": "d00f07b0-594c-11e4-8ed6-0800200c9a66",
                "name": "Experiment 1",
                "audience": "all",
                "device_types": [ "ios", "android" ],
                "variants": [{
                        "push": {
                        "notification": {
                            "alert": "message 1"
                        }
                        },
                        "id": 0,
                    },
                    {
                        "push": {
                        "notification": {
                        "alert": "message 2"
                        }
                    },
                    "id": 1,
                }]
            }
        }

        experiment_object_example = {
            "name": 'Neat experiment',
            "audience": "all",
            "device_types": "all",
            "variants": [
                {
                    "push": {
                        "notification": {
                            "alert": "I love cereal"
                        }
                    }
                },
                {
                    "push": {
                        "notification": {
                            "alert": "I prefer oatmeal"
                        }
                    }
                }
            ]
        }

        describe '#experiment_object' do 
            it 'correctly formats experiment object with other classes' do 
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
                experiment.audience = 'all'
                experiment.device_types = 'all'
                experiment.variants << variant_one.payload
                experiment.variants << variant_two.payload 
                ab_test = UA::AbTest.new(client: airship)
                ab_test.experiment_object = experiment.payload
                expect(ab_test.experiment_object).to eq(experiment_object_example)
            end
        end

        describe '#list_ab_test' do 
            it 'returns the correct response' do 
                experiment = UA::AbTest.new(client: airship)

                allow(airship).to receive(:send_request).and_return(list_experiment_response)
                actual_resp = experiment.list_ab_test
                expect(actual_resp).to eq(list_experiment_response)
            end
        end

        describe '#create_ab_test_do' do
            it ' returns a 201 HTTP response' do 
                experiment = UA::AbTest.new(client: airship)

                allow(airship).to receive(:send_request).and_return(create_ab_test_response)
                actual_resp = experiment.create_ab_test
                expect(actual_resp).to eq(create_ab_test_response)
            end
        end

        describe '#list_scheduled_ab_test' do  
            it 'returns a 200 HTTP resposne' do 
                experiment = UA::AbTest.new(client: airship)

                allow(airship).to receive(:send_request).and_return(list_scheduled_response)
                actual_resp = experiment.list_scheduled_ab_test
                expect(actual_resp).to eq(list_scheduled_response)
            end
        end

        describe '#delete_ab_test' do 
            it 'returns a 200 HTTP response' do 
                experiment = UA::AbTest.new(client: airship)
                experiment.experiment_id = '0f7704e9-5dc0-4f7d-9964-e89055701b0a'

                allow(airship).to receive(:send_request).and_return(delete_ab_test_response)
                actual_resp = experiment.delete_ab_test
                expect(actual_resp).to eq(delete_ab_test_response)
            end

            it 'fails when experiment_id is not set' do 
                experiment = UA::AbTest.new(client: airship)
                expect{experiment.delete_ab_test}.to raise_error(ArgumentError)
            end
        end

        describe '#validate_ab_test' do 
            it 'returns a 200 HTTP response' do 
                experiment = UA::AbTest.new(client: airship)

                allow(airship).to receive(:send_request).and_return(delete_ab_test_response)
                actual_resp = experiment.validate_ab_test
                expect(actual_resp).to eq(delete_ab_test_response)
            end
        end

        describe '#lookup_ab_test' do 
            it 'returns a 200 HTTP response' do 
                experiment = UA::AbTest.new(client: airship)
                experiment.experiment_id = '0f7704e9-5dc0-4f7d-9964-e89055701b0a'

                allow(airship).to receive(:send_request).and_return(lookup_ab_test_response)
                actual_resp= experiment.lookup_ab_test
                expect(actual_resp).to eq(lookup_ab_test_response)
            end

            it 'fails when experiment_id is not set' do 
                experiment = UA::AbTest.new(client: airship)
                expect{experiment.lookup_ab_test}.to raise_error(ArgumentError)
            end
        end

    end
end