require 'spec_helper'
require 'urbanairship'
require 'urbanairship/ab_tests/variant'

describe Urbanairship::AbTests do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::AbTests:Variant do

        describe '#payload' do 
            it 'correctly formats payload for variant' do
            end

            it 'fails when push is not included' do 
            end
        end
    end
end
