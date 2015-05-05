require 'spec_helper'

describe Urbanairship::Airship do
	let(:UA) { Urbanairship }

	it 'is instantiated with a "key" and "secret"' do
		expect(UA::Airship.new('key', 'secret')).not_to be_nil
	end
end
