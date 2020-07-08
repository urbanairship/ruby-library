require 'spec_helper'
require 'urbanairship'
require 'urbanairship/automations/automation'

describe Urbanairship::Automations do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::Automations::Automation do

        list_automations_response = {
            "ok": true,
            "pipelines": [
            {
                "creation_time": "2015-03-20T18:37:23",
                "enabled": true,
                "immediate_trigger": {
                    "tag_added": { "tag": "bought_shoes" }
                },
                "last_modified_time": "2015-03-20T19:35:12",
                "name": "Shoe buyers",
                "outcome": {
                    "push": {
                        "audience": "triggered",
                        "device_types": [ "android" ],
                        "notification": { "alert": "So you like shoes, huh?" }
                    }
                },
                "status": "live",
                "uid": "3987f98s-89s3-cx98-8z89-89adjkl29zds",
                "url": "https://go.urbanairship.com/api/pipelines/3987f98s-89s3-cx98-8z89-89adjkl29zds"
            }
            ]
        }

        describe '#format_url_with_params' do
            it 'formats a url with all the queries' do
                automation = UA::Automation.new(client: airship)
                automation.enabled = TRUE
                automation.offset = 5
                automation.limit = 5
                result = automation.format_url_with_params
                expect(result).to eq('https://go.urbanairship.com/api/pipelines/?limit=5&enabled=true&offset=5')
            end

            it 'formats a url with two queries' do
                automation = UA::Automation.new(client: airship)
                automation.enabled = TRUE
                automation.limit = 5
                result = automation.format_url_with_params
                expect(result).to eq('https://go.urbanairship.com/api/pipelines/?limit=5&enabled=true')
            end

            it 'formats a url with one query' do
                automation = UA::Automation.new(client: airship)
                automation.enabled = TRUE
                result = automation.format_url_with_params
                expect(result).to eq('https://go.urbanairship.com/api/pipelines/?enabled=true')
            end
        end

        describe '#list_automations' do 
            it 'returns an 200 code with a properly formatted GET request' do
                automation = UA::Automation.new(client: airship)

                allow(airship).to receive(:send_request).and_return(list_automations_response)
                actual_resp = automation.list_automations
                expect(actual_resp).to eq(list_automations_response)
            end
        end

    end

end