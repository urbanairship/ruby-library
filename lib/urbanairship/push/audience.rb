require 'urbanairship/util'
require 'urbanairship/common'


module Urbanairship
  module Push
    module Audience
      include Urbanairship::Common
      UUID_PATTERN = /^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}$/
      DEVICE_TOKEN_PATTERN = /^\h{64}$/
      DEVICE_PIN_PATTERN = /^\h{8}$/
      DATE_TERMS = %i(minutes hours days weeks months years)


      # Methods to select a single iOS Channel, Android Channel, Amazon Channel,
      # Android APID, Windows 8 APID, or Windows Phone 8 APID respectively.
      #
      # @example
      #   ios_channel(<channel>) # ==>
      #     {:ios_channel=>"<channel>"}
      %w(ios_channel android_channel amazon_channel apid wns mpns).each do |name|
        define_method(name) do |uuid|
          { name.to_sym => cleanup(uuid) }
        end
      end

      # Select a single iOS device token
      def device_token(token)
        Util.validate(token, 'device_token', DEVICE_TOKEN_PATTERN)
        { device_token: token.upcase.strip }
      end

      # Select a single BlackBerry PIN
      def device_pin(pin)
        Util.validate(pin, 'pin', DEVICE_PIN_PATTERN)
        { device_pin: pin.downcase.strip }
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

      # Select a recent date range for a location selector.
      # Valid selectors are:
      #   :minutes :hours :days :weeks :months :years
      #
      # @example
      #   recent_date(months: 6)  # => { recent: { months: 6 }}
      #   recent_date(weeks: 3)  # => { recent: { weeks: 3 }}
      def recent_date(**params)
        fail ArgumentError, 'Only one range allowed' if params.size != 1
        k, v = params.first
        unless DATE_TERMS.include?(k)
          fail ArgumentError, "#{k} not in #{DATE_TERMS}"
        end
        { recent: { k => v } }
      end

      # Select an absolute date range for a location selector.
      #
      # @param resolution [Symbol] Time resolution specifier, one of
      #                            :minutes :hours :days :weeks :months :years
      # @param start [String] UTC start time in ISO 8601 format.
      # @param the_end [String] UTC end time in ISO 8601 format.
      #
      # @example
      #   absolute_date(resolution: :months, start: '2013-01', the_end: '2013-06')
      #   #=> {months: {end: '2013-06', start: '2013-01'}}
      #
      #   absolute_date(resolution: :minutes, start: '2012-01-01 12:00',
      #                 the_end: '2012-01-01 12:45')
      #   #=> {minutes: {end: '2012-01-01 12:45', start: '2012-01-01 12:00'}}
      def absolute_date(resolution: required('resolution'), start: required('start'), the_end: required('the_end'))
        unless DATE_TERMS.include?(resolution)
          fail ArgumentError, "#{resolution} not in #{DATE_TERMS}"
        end
        { resolution => { start: start, end: the_end } }
      end

      # Select a location expression.
      #
      # Location selectors are made up of either an id or an alias and a date
      # period specifier. Use a date specification function to generate the time
      # period specifier.
      #
      # @example ID location
      #   location(id: '4oFkxX7RcUdirjtaenEQIV', date: recent_date(days: 4))
      #   #=> {location: {date: {recent: {days: 4}},
      #       id: '4oFkxX7RcUdirjtaenEQIV'}}
      #
      # @example Alias location
      #   location(us_zip: '94103', date: absolute_date(
      #            resolution: 'days', start: '2012-01-01', end: '2012-01-15'))
      #   #=> {location: {date: {days: {end: '2012-01-15',
      #       start: '2012-01-01'}}, us_zip: '94103'}}
      def location(date: required('date'), **params)
        unless params.size == 1
          fail ArgumentError, 'One location specifier required'
        end
        params[:date] = date
        { location: params }
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
