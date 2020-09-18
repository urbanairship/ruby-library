require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/attribute'

describe Urbanairship::Devices do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

    describe Urbanairship::Devices::Attribute do
        describe '#payload' do 
            it 'formats the payload correctly for date attribute'
            end

            it 'formats the payload correctly for number attribute'
            end

            it 'formats the payload correctly for text attribute'
            end
        end
    end
end
