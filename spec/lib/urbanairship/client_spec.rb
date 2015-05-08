require 'spec_helper'

require 'urbanairship/client'

describe Urbanairship::Client do
  UA = Urbanairship

  it 'is instantiated with a "key" and "secret"' do
    expect(UA::Client.new(key: '123', secret: 'abc')).not_to be_nil
  end
end
