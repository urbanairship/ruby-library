require 'urbanairship/util'
require 'urbanairship/common'


module Urbanairship
  module Push
    module Audience
      include Urbanairship::Common
      UUID_PATTERN = /^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}$/
      DEVICE_TOKEN_PATTERN = /^\h{64}$/
      DATE_TERMS = %i(minutes hours days weeks months years)


      # Methods to select a single iOS Channel, Android Channel, Amazon Channel,
      # Web Channel, Open Channel, Android APID, or Windows APID respectively.
      #
      # @example
      #   ios_channel(<channel>) # ==>
      #     {:ios_channel=>"<channel>"}
      %w(ios_channel android_channel amazon_channel channel open_channel apid wns).each do |name|
        define_method(name) do |uuid|
          { name.to_sym => cleanup(uuid) }
        end
      end

      # Select a single iOS device token
      def device_token(token)
        Util.validate(token, 'device_token', DEVICE_TOKEN_PATTERN)
        { device_token: token.upcase.strip }
      end

      # Select a single tag
      def tag(tag, group: nil)
        tag_params = { tag: tag }
        tag_params[:group] = group unless group.nil?
        tag_params
      end

      # Select a single alias
      def alias(an_alias)
        { alias: an_alias }
      end

      # Select a single segment using segment_id
      def segment(segment)
        { segment: segment }
      end

      # Select a single named user
      def named_user(named_user)
        { named_user: named_user }
      end

      # Select devices that match at least one of the given selectors.
      #
      # @example
      #   or(tag('sports'), tag('business')) # ==>
      #     {or: [{tag: 'sports'}, {tag: 'business'}]}
      def or(*children)
        { or: children }
      end

      # Select devices that match all of the given selectors.
      #
      # @example
      #   and(tag('sports'), tag('business')) # ==>
      #     {and: [{tag: 'sports'}, {tag: 'business'}]}
      def and(*children)
        { and: children }
      end

      # Select devices that do not match the given selectors.
      #
      # @example
      #   not(and_(tag('sports'), tag('business'))) # ==>
      #     {not: {and: [{tag: 'sports'}, {tag: 'business'}]}}
      def not(child)
        { not: child }
      end

      private

      # Clean up a UUID for use in the library
      def cleanup(uuid)
        Util.validate(uuid, 'UUID', UUID_PATTERN)
        uuid.downcase.strip
      end
    end
  end
end
