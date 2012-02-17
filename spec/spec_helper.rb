require 'base64'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '/../lib/urbanairship')


RSpec.configure do |config|
  config.after(:each) do
    # reset configuration
    Urbanairship.application_key = nil
    Urbanairship.application_secret = nil
    Urbanairship.master_secret = nil
    Urbanairship.logger = nil

    FakeWeb.instance_variable_set("@last_request", nil)
  end
end
