require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/attribute'

describe Urbanairship::Devices do
    UA = Urbanairship
    airship = UA::Client.new(key: '123', secret: 'abc')

   date_attribute_payload = {
      "attribute": "birth_date",
      "operator": "equals",
      "precision": "month_day",
      "value": "05-04"
   }

    number_attribute_payload = {
      "attribute": "lifetime_value",
      "operator": "greater",
      "value": 15000
   }

    text_attribute_payload = {
      "attribute": "item_purchased",
      "operator": "contains",
      "value": "jeans"
   }

    describe Urbanairship::Devices::Attribute do
        describe '#payload' do 
            it 'formats the payload correctly for date attribute' do
                new_attribute = UA::Attribute.new(client: airship)
                new_attribute.attribute = 'birth_date'
                new_attribute.operator = 'equals'
                new_attribute.precision = 'month_day'
                new_attribute.value = '05-04'
                expect(new_attribute.payload).to eq(date_attribute_payload)
            end

            it 'formats the payload correctly for number attribute' do
                new_attribute = UA::Attribute.new(client: airship)
                new_attribute.attribute = 'lifetime_value'
                new_attribute.operator = 'greater'
                new_attribute.value = 15000
                expect(new_attribute.payload).to eq(number_attribute_payload)
            end

            it 'formats the payload correctly for text attribute' do
                new_attribute = UA::Attribute.new(client: airship)
                new_attribute.attribute = 'item_purchased'
                new_attribute.operator = 'contains'
                new_attribute.value = 'jeans'
                expect(new_attribute.payload).to eq(text_attribute_payload)
            end
        end
    end
end
