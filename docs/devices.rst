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

    channel_list.each do |channel|
        puts(channel)
    end

Channel Lookup
--------------

Device metadata is fetched for a specific channel by using
:rb:class:`ChannelInfo` with the method ``lookup('uuid')``.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_client = UA::ChannelInfo.new(airship)
    channel_info = channel_client.lookup(uuid: 'uuid')
    puts(channel_info)