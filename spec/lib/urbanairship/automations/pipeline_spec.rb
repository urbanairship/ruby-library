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

        simple_pipeline_object = {
        "immediate_trigger": {
            "tag_added": {
                "tag": "new_customer",
                "group": "crm"
                }
            },
        "enabled": true,
        "outcome": {
            "push": {
                "audience": "triggered",
                "device_types": "all",
                "notification": {
                    "alert": "Hello new customer!"
                    
                    }
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

            it 'can format a simpler payload' do
                pipeline = UA::Pipeline.new(client: airship)
                pipeline.immediate_trigger = {
                "tag_added": {
                    "tag": "new_customer",
                    "group": "crm"
                    }
                }
                pipeline.enabled = true 
                pipeline.outcome = {
                "push": {
                    "audience": "triggered",
                    "device_types": "all",
                    "notification": {
                        "alert": "Hello new customer!"
                        
                        }
                    }
                }
                result = pipeline.payload 
                expect(result).to eq(simple_pipeline_object)
            end

            it 'fails if enabled is not set' do
                pipeline = UA::Pipeline.new(client: airship)
                pipeline.name = "You can tell its a pipeline cause of how it is"
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

                expect{pipeline.payload}.to raise_error(ArgumentError)
            end

            it 'fails if outcoome is not set' do
                pipeline = UA::Pipeline.new(client: airship)
                pipeline.name = "You can tell its a pipeline cause of how it is"
                pipeline.enabled = true
                pipeline.immediate_trigger = "first_open"
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

                expect{pipeline.payload}.to raise_error(ArgumentError)
            end
        end 

    end   
end