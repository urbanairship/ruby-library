require 'urbanairship'

module Urbanairship
  module Devices
    class Sms
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_reader :msisdn, :sender, :opted_in
      attr_accessor :sender

      def initialize(client: required('client'))
        @client = client
        @sender = sender
        @msisdn = nil
        @opted_in = nil
      end
    end
  end
end
