require 'urbanairship'
require 'json'

module Urbanairship
  module Devices
    class MmsNotification
      include Urbanairship::Common
      include Urbanairship::Loggable

      attr_accessor :fallback_text,
                    :shorten_links,
                    :content_length,
                    :content_type,
                    :url,
                    :text,
                    :subject

      def initialize(client: required('client'))
        @client = client
        @fallback_text = nil
        @shorten_links = nil
        @content_length = nil
        @content_type = nil
        @url = nil
        @text = nil
        @subject = nil
      end

    end
  end
end
