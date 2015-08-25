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
    channel_list = UA::ChannelList.new(client: airship)

    channel_list.each do |channel|
        puts(channel)
    end

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
    feedback = UA::Feedback.new(client: airship)
    tokens = feedback.device_token(since: since)
    apids = feedback.apid(since: since)


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


Device Token Count
------------------

Get the total iOS device tokens registered to the application.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_token_list = UA::DeviceTokenList.new(client: airship)
    puts(device_token_list.count)


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

List all APIDs for the application:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    apid_list = UA::APIDList.new(client: airship)
    apid_list.each do |apid|
        puts(apid)
    end


Blackberry PIN Register
-----------------------

Register a PIN with the application. This will mark the PIN as active in
the system. You can also set up an alias and tags for the pin.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_pin = UA::DevicePin.new(client: airship)
    resp = device_pin.register(pin: '12345678', pin_alias: nil, tags: nil)
    puts(resp)

.. note::
    ``pin_alias`` and ``tags`` are optional parameters for this command.
    If no ``pin_alias`` is provided, any existing alias will be removed from the device
    record. To empty the tag set, send an empty array of tags. If the tags
    array is missing from the request, the tags will not be modified.


Blackberry PIN Lookup
---------------------

Get information on a particular BlackBerry PIN:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_pin = UA::DevicePin.new(client: airship)
    resp = device_pin.lookup(pin: 'device_pin')
    puts(resp)


Blackberry PIN Deactivate
-------------------------

Deactive a Blackberry pin for the application.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_pin = UA::DevicePin.new(client: airship)
    resp = device_pin.deactivate(pin: 'device_pin')
    puts(resp)


Blackberry PIN List
-------------------

Get a list of all Blackberry PINs registered to the application.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    device_pin_list = UA::DevicePinList.new(client: airship)
    device_pin_list.each do |pin|
        puts(pin)
    end
