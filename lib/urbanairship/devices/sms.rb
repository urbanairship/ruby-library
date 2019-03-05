require 'urbanairship'

module Urbanairship
  module Devices
    class Sms
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :sender

      def initialize(sender: required('sender'))
        @sender = sender
      end
    end
  end
end
