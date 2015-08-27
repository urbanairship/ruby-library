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
        fail ArgumentError, 'type needs to be a string' unless type == nil or type.is_a? String
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
        fail ArgumentError, 'from_alias needs to be a string' unless from_alias.is_a? String or from_alias.kind_of? Array
        url = LOCATION_URL + 'from-alias?'
        if from_alias.kind_of? Array
          from_alias.each do |a|
            url += a + '&'
          end
          url = url.chop
        else
          url += from_alias
        end

        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location info from alias #{from_alias}")
        resp
      end

      def polygon_lookup(polygon_id: required('polygon_id'), zoom: required('zoom'))
        fail ArgumentError, 'polygon_id needs to be a string' unless polygon_id.is_a? String
        fail ArgumentError, 'zoom needs to be an integer' unless zoom.is_a? Integer

        url = LOCATION_URL + polygon_id + '?zoom=' + zoom
        resp = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Retrieved location info for polygon #{polygon_id} and zoom level #{zoom}")
        resp
      end

      def date_range
        resp = @client.send_request(
          method: 'GET',
          url: SEGMENTS_URL + 'dates/'
        )
        logger.info("Retrieved date range info for locations")
        resp
      end
    end
  end
end