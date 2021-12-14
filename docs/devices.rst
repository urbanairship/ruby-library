Retrieving Device Information
=============================

Channel Listing
---------------

Device lists are fetched by instantiating an iterator object
using :rb:class:`ChannelList`. For more information, see `the API
documentation for channels <http://docs.airship.com/api/ua.html#channels>`_.
The ``count`` method will give you the number of channels over which you have iterated.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_list = UA::ChannelList.new(client: airship)

    channel_list.each do |channel|
        puts(channel)
    end

    puts(channel_list.count)

Channel Lookup
--------------

Device metadata is fetched for a specific channel by using
:rb:class:`ChannelInfo` with the method ``lookup(uuid: 'uuid')``.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_client = UA::ChannelInfo.new(client: airship)
    channel_info = channel_client.lookup(uuid: 'uuid')
    puts(channel_info)

Device Token Lookup
-------------------

Get information on a particular iOS device token:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_token = UA::DeviceToken.new(client: airship)
    resp = device_token.lookup(token: 'device_token')
    puts(resp)


Device Token List
-----------------

Get a list of iOS device tokens for the application:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_token_list = UA::DeviceTokenList.new(client: airship)
    device_token_list.each do |token|
        puts(token)
    end


APID Lookup
-----------

Get information on a particular Android APID:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    apid = UA::APID.new(client: airship)
    resp = apid.lookup(apid: 'apid')
    puts(resp)


APID List
---------

List all APIDs for the application. Afterwards, you can get the number of apids
that have been iterated over by using the ``count`` method.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    apid_list = UA::APIDList.new(client: airship)
    apid_list.each do |apid|
        puts(apid)
    end
    puts(apid_list.count)


Subscription Lists
---------

Subscribe or Unsubscribe Channels to/from Subscription Lists.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    subscription_lists = UA::SubscriptionLists.new(client: airship)
    response = subscription_lists.subscribe(list_id: "some-list", email_addresses: ["test1@example.com", "test2@example.com"])
    puts(response)
