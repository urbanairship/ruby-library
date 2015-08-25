require 'urbanairship'


module Urbanairship
  module Push
    class Location
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def name_lookup(name: required('name'), type: nil)
        fail ArgumentError, 'name needs to be a string' unless name.is_a? String

        url = LOCATION_URL + '?q=' + name
        url += '&type=' + type unless type.nil?
        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location information for #{name}")
        resp
      end

      def coordinates_lookup(latitude: required('latitude'), longitude: required('longitude'), type: nil)
        fail ArgumentError,
          'latitude and longitude need to be numbers' unless latitude.is_a? Numeric and longitude.is_a? Numeric
        url = LOCATION_URL + latitude.to_s + ',' + longitude.to_s
        url += '?type=' + type unless type.nil?
        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location information for latitude #{latitude} and longitude #{longitude}")
        resp
      end

      def bounding_box_lookup(lat1: required('lat1'), long1: required('long1'),
                              lat2: required('lat2'), long2: required('long2'), type: nil)

        fail ArgumentError,
           'lat1, long1, lat2, and long2 need to be numbers' unless lat1.is_a? Numeric and long2.is_a? Numeric\
           and lat2.is_a? Numeric and long2.is_a? Numeric
        url = LOCATION_URL + lat1.to_s + ',' + long1.to_s + ',' + lat2.to_s + ',' + long2.to_s
        url += '?type=' + type unless type.nil?
        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location information for bounding box with lat1 #{lat1}, long1 #{long1}," +
          " lat2 #{lat2}, and long2 #{long2}")
        resp
      end

      def alias_lookup(from_alias: required('from_alias'))
        fail ArgumentError, 'from_alias needs to be a string' unless from_alias.is_a? String

        url = LOCATION_URL + 'from-alias?' + from_alias
        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location info from alias #{from_alias}")
        resp
      end
    end
  end
end