require 'urbanairship'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :

      def initialize(client: required('client'))
        @client = client
        @ua_address = nil
      end

      def create_and_send

      end

      def email_channel
        fail ArgumentError, 'address must be set to register email channel' if @ua_address.nil?
      end

      def sms_channel

      end

      def mms_notification

      end

      def open_channels

      end

      def validate

      end

      def operation

      end
