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
                automation.enabled = True
                automation.offset = 5
                automation.limit = 5
                result = automation.format_url_with_params
                expect(result).to eq('https://go.urbanairship.com/api/pipelines/?enabled=True&limit=5&offset=5')
            end
        end

    end

end