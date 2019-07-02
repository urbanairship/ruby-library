require 'urbanairship'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :

      def initialize(client: required('client'))
        
      end

      def create_and_send
