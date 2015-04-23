require 'urbanairship/util'

module Urbanairship
  module Push
    module Audience
      UUID_PATTERN = /^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}$/
      DEVICE_TOKEN_PATTERN = /^\h{64}$/
      DEVICE_PIN_PATTERN = /^\h{8}$/
      DATE_TERMS = %i(minutes hours days weeks months years)


      # Select a single iOS Channel
      def ios_channel(uuid)
        { ios_channel: cleanup(uuid) }
      end

      # Select a single Android Channel
      def android_channel(uuid)
        { android_channel: cleanup(uuid) }
      end

      # Select a single Amazon Channel
      def amazon_channel(uuid)
        { amazon_channel: cleanup(uuid) }
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

      # Select a single Android APID
      def apid(uuid)
        { apid: cleanup(uuid) }
      end

      # Select a single Windows 8 APID
      def wns(uuid)
        { wns: cleanup(uuid) }
      end

      # Select a single Windows Phone 8 APID
      def mpns(uuid)
        { mpns: cleanup(uuid) }
      end

      # Select a single tag
      def tag(tag)
        { tag: tag }
      end

      # Select a single alias
      def alias(an_alias)
        { alias: an_alias }
      end

      # Select a single segment
      def segment(segment)
        { segment: segment }
      end

      # Select devices that match at least one of the given selectors.
      #
      # @example
      #   or_(tag('sports'), tag('business')) # ==>
      #     {or: [{tag: 'sports'}, {tag: 'business'}]}
      def or_(*children)
        { or: children }
      end

      # Select devices that match all of the given selectors.
      #
      # @example
      #   and_(tag('sports'), tag('business')) # ==>
      #     {and: [{tag: 'sports'}, {tag: 'business'}]}
      def and_(*children)
        { and: children }
      end

      # Select devices that do not match the given selectors.
      #
      # @example
      #   not_(and_(tag('sports'), tag('business'))) # ==>
      #     {not: {and: [{tag: 'sports'}, {tag: 'business'}]}}
      def not_(child)
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
        raise ArgumentError, "Only one range allowed" if params.size != 1
        k, v = params.first
        unless DATE_TERMS.include?(k)
          raise ArgumentError, "#{k} not in #{DATE_TERMS}"
        end
        { recent: { k => v }}
      end

      # Select an absolute date range for a location selector.
      #
      # @param resolution [Symbol] Time resolution specifier, one of
      #                            :minutes :hours :days :weeks :months :years
      # @param start [String] UTC start time in ISO 8601 format.
      # @param the_end [String] UTC end time in ISO 8601 format.
      #
      # @example
      #   absolute_date(resolution: :months, start: '2013-01', end: '2013-06')
      #   #=> {months: {end: '2013-06', start: '2013-01'}}
      #
      #   absolute_date(resolution: 'minutes', start: '2012-01-01 12:00',
      #                 end: '2012-01-01 12:45')
      #   #=> {minutes: {end: '2012-01-01 12:45', start: '2012-01-01 12:00'}}
      def absolute_date(resolution:, start:, the_end:)
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
      def location(date:, **params)
        fail ArgumentError, 'One location specifier required' unless params.size == 1
        params[:date] = date
        { location: params }
      end

      private

      def cleanup(uuid)
        Util.validate(uuid, 'UUID', UUID_PATTERN)
        uuid.downcase.strip
      end
    end
  end
end
