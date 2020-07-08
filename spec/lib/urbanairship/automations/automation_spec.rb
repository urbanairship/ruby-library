require 'spec_helper'
require 'urbanairship'
require 'urbanairship/automations/automation'

describe Urbanairship::Automations do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::Automations::Automation do

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

    end

end