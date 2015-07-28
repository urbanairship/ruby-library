require 'urbanairship'
require 'urbanairship/common'

module Urbanairship
  module Devices
    class ChannelInfo

      attr_writer :client
      include Urbanairship::Common

      def initialize(client)
        @client = client
      end

      def lookup(uuid)
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid,
          version: 3
        )
        from_payload(response)
      end

      def from_payload(response)
        channel = response['body']['channel']
        channel.each do |k,v|
          instance_variable_set("@#{k}", v)
        self
        end
      end
    end

    class ChannelList
      include Urbanairship::Common
      include Enumerable

      def initialize(client)
        @client = client
        @data_attribute = 'channels'
        response = @client.send_request(
            method: 'GET',
            url: CHANNEL_URL,
            version: 3
        )
        @channel_list = response['body']['channels']
      end

      def each
        @channel_list.each do | value |
          yield value
        end
      end

    end
  end
end





#
#         class ChannelList(DeviceList):
#             """Iterator for listing all channels for this application.
#
#     :ivar limit: Number of entries to fetch in each page request.
#     :returns: Each ``next`` returns a :py:class:`ChannelInfo` object.
#
#     """
#         start_url = common.CHANNEL_URL
#         data_attribute = 'channels'
#         id_key = 'channel_id'
#
#         def __next__(self):
#             try:
#             return ChannelInfo.from_payload(
#                 next(self._token_iter),
#         self.id_key
#         )
#         except StopIteration:
#                    self._fetch_next_page()
#         return ChannelInfo.from_payload(
#             next(self._token_iter),
#         self.id_key
#         )
#
#         def next(self):
#             """Necessary for iteration to work with Python 2.*."""
#         return self.__next__()
#
#
#         class APIDList(DeviceList):
#             """Iterator for listing all APIDs for this application.
#
#     :ivar limit: Number of entries to fetch in each page request.
#     :returns: Each ``next`` returns a :py:class:`DeviceInfo` object.
#
#     """
#         start_url = common.APID_URL
#         data_attribute = 'apids'
#         id_key = 'apid'
#
#
#         class DevicePINList(DeviceList):
#             """Iterator for listing all device PINs for this application.
#
#     :ivar limit: Number of entries to fetch in each page request.
#     :returns: Each ``next`` returns a :py:class:`DeviceInfo` object.
#
#     """
#         start_url = common.DEVICE_PIN_URL
#         data_attribute = 'device_pins'
#         id_key = 'device_pin'
#
#
#         class Feedback(object):
#             """Return device tokens or APIDs marked inactive since this timestamp."""
#
#         @classmethod
#         def device_token(cls, airship, since):
#             url = common.DT_FEEDBACK_URL
#         return cls._get_feedback(airship, since, url)
#
#         @classmethod
#         def apid(cls, airship, since):
#             url = common.APID_FEEDBACK_URL
#         return cls._get_feedback(airship, since, url)
#
#         @classmethod
#         def _get_feedback(cls, airship, since, url):
#             response = airship._request(
#                 method='GET',
#                 body='',
#                 url=url,
#                 params={'since': since.isoformat()},
#             version=3
#         )
#         data = response.json()
#         for r in data:
#           r['marked_inactive_on'] = datetime.datetime.strptime(
#               r['marked_inactive_on'],
#               '%Y-%m-%d %H:%M:%S'
#           )
#           return data
