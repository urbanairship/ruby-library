Retrieving Device Information
=============================

Channel Listing
---------------

Device lists are fetched by instantiating an iterator object 
using :py:class:`ChannelList`.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)

   channel_id = None
   for channel in ua.ChannelList(airship):
       channel_id = channel.channel_id
       print (channel.channel_id, channel.device_type, channel.tags,
              channel.push_address, channel.alias, channel.opt_in)

.. automodule:: urbanairship.devices.devicelist
   :members: ChannelList, ChannelInfo
   :noindex:

Channel Lookup
--------------
     
Device metadata is fetched for a specific channel by using
:py:class:`ChannelLookup:lookup`.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, app_secret)

   channel = ua.ChannelInfo.lookup(airship, device_channel)
   print (channel.channel_id, channel.device_type, channel.tags,
          channel.push_address, channel.alias, channel.opt_in)

.. automodule:: urbanairship.devices.devicelist
   :members: ChannelInfo
   :noindex:

Blackberry PIN Lookup
---------------------

Device metadata is fetched by instantiating a lookup for a specific
device PIN by using :py:class:`DevicePINInfo:pin_lookup`

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, app_secret)

   device_pin_info = ua.DevicePINInfo.pin_lookup(airship, device_pin)
   print (device_pin_info) 

.. automodule:: urbanairship.devices.devicelist
   :members: DevicePINInfo
   :noindex:

Device Listing
--------------

Device lists are fetched by instantiating an iterator object for each
type of device. The available iterators are :py:class:`DeviceTokenList`,
:py:class:`APIDList`, and :py:class:`DevicePINList`.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)

   for dt in ua.DeviceTokenList(airship):
      print (dt.device_token, dt.tags or [], dt.active)

.. automodule:: urbanairship.devices.devicelist
   :members: DeviceTokenList, DevicePINList, APIDList, DeviceInfo
   :noindex:

Feedback
--------
Feedback returns a list of dictionaries of device tokens/APIDs that the
respective push provider has told us are uninstalled since the given
timestamp. For more information, see: `the documentation on feedback
<feedback>`_.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   since = datetime.datetime.utcnow() - datetime.timedelta(days=1)
   tokens = ua.Feedback.device_token(airship, since)
   apids = ua.Feedback.apid(airship, since)

.. automodule:: urbanairship.devices.devicelist
   :members: Feedback
   :noindex:

.. _feedback: http://docs.urbanairship.com/api/ua.html#feedback
