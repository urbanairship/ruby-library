require 'spec_helper'
require 'urbanairship'
require 'urbanairship/automations/pipeline'

describe Urbanairship::Automations do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::Automations::Pipeline do
        pipeline_object = {
            "name":"You can tell its a pipeline cause of how it is",
            "enabled":true,
            "immediate_trigger":"first_open",
            "outcome":{
                "push":{
                    "audience":"triggered",
                    "device_types":[
                        "ios",
                        "android"
                    ],
                    "notification":{
                        "alert":"That's pretty neat"
                    }
                }
            },
            "timing":{
                "delay":{
                    "seconds":7200
                },
                "schedule":{
                    "type":"local",
                    "miss_behavior":"wait",
                    "dayparts":[
                        {
                        "days_of_week":[
                            "thursday"
                        ],
                        "allowed_times":[
                            {
                                "preferred":"21:30:00"
                            }
                        ]
                        }
                    ]
                }
            }
            }
        
        describe '#paylaod' do
            it 'can correctly format a pipeline object payload' do
                pipeline = UA::Pipeline.new(client: airship)
                pipeline.name = "You can tell its a pipeline cause of how it is"
                pipeline.enabled = true
                pipeline.immediate_trigger = "first_open"
                pipeline.outcome = {
                    "push":{
                        "audience":"triggered",
                        "device_types":[
                            "ios",
                            "android"
                        ],
                        "notification":{
                            "alert":"That's pretty neat"
                        }
                    }
                }
                pipeline.timing = {
                    "delay":{
                        "seconds":7200
                    },
                    "schedule":{
                        "type":"local",
                        "miss_behavior":"wait",
                        "dayparts":[
                            {
                            "days_of_week":[
                                "thursday"
                            ],
                            "allowed_times":[
                                {
                                    "preferred":"21:30:00"
                                }
                            ]
                            }
                        ]
                    }
                }

                result = pipeline.payload
                expect(result).to eq(pipeline_object)
            end
        end 

    end
        
end