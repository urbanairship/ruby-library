require 'urbanairship'

module Urbanairship
  module Devices
    class Sms
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :msisdn, :sender, :opted_in, :sender

      def initialize(client: required('client'))
        @client = client
        @sender = nil
        @msisdn = nil
        @opted_in = nil
      end

      def register
        
      end
    end
  end
end
