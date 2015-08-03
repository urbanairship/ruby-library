Retrieving Device Information
=============================

Channel Listing
---------------

Device lists are fetched by instantiating an iterator object
using :rb:class:`ChannelList`. For more information, see:
http://docs.urbanairship.com/api/ua.html#channels

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_list = UA::ChannelList.new(airship)

    channel_list.each |channel|
        puts(channel)

Channel Lookup
--------------

Device metadata is fetched for a specific channel by using
:rb:class:`ChannelInfo` with the method ``lookup('uuid')``.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel = UA::ChannelInfo.new(airship).lookup('uuid')
    puts(channel)

Feedback
--------

Feedback returns a list of dictionaries of device tokens/APIDs that the
respective push provider has told us are uninstalled since the given
timestamp. For more information, see:
http://docs.urbanairship.com/api/ua.html#feedback

.. code-block:: ruby

    require 'urbanairship'
    require 'time
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    since = (Time.now.utc - (60 * 60 * 24 * 3)).iso8601
    feedback = UA::Feedback.new(airship)
    tokens = feedback.device_token(since)
    apids = feedback.apid(since)