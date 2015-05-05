require 'spec_helper'

require 'urbanairship/airship'

describe Urbanairship::Airship do
	UA = Urbanairship

	it 'is instantiated with a "key" and "secret"' do
		expect(UA::Airship.new(key: '123', secret: 'abc')).not_to be_nil
	end
end
