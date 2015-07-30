Retrieving Device Information
=============================

Channel Listing
---------------

Device lists are fetched by instantiating an iterator object
using :rb:class:`ChannelList`.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_list = UA::ChannelList.new(airship)

    channel_list.each |channel|
        print (
            channel['channel_id'],
            channel['device_type'],
            channel['tags'],
            channel['push_address'],
            channel['alias'],
            channel['opt_in']
        )

Channel Lookup
--------------

Device metadata is fetched for a specific channel by using
:rb:class:`ChannelLookup:lookup`.

.. code-block:: ruby
    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel = UA::ChannelInfo.new(airship).lookup('uuid')
    puts(channel)