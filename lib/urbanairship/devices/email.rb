require 'urbanairship'

module Urbanairship
  module  Devices
    class Email
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :type, :commercial_opted_in, :address, :timezone, :locale_country, :locale_language

      def initialize(client: required('client'))
        @client = client
        @type = nil
        @commercial_opted_in = nil
        @address = nil
        @timezone = nil
        @locale_country = nil
        @locale_language = nil
      end

      def register
         
      end

    end
  end
end
