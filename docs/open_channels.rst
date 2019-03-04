Open Channels
=============

Create Open Channel
-------------------
Upon creation an open channel needs an address, boolean opt-in value,
and an open platform. Further params are optional, and can be set when
updating an open channel.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    open_channel = UA::OpenChannel.new(client: airship)
    open_channel.opt_in = true
    open_channel.address = 'address'
    open_channel.open_platform = 'sms'
    open_channel.create()

.. note::

    The creation of an open channel should yield a 200 response. This is the minimum
    required to create an open channel. `opt_in` must be a boolean, `address` and
    `open_platform` must be strings.

Update Open Channel
-------------------
Updating an open channel is done by updating the attributes on the open channel.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    open_channel = UA::OpenChannel.new(client: airship)
    open_channel.opt_in = true
    open_channel.address = 'address'
    open_channel.open_platform = 'sms'
    open_channel.channel_id = 'channel_id'
    open_channel.tags= ['tag1', 'tag2']
    open_channel.identifiers = 'identifiers'

    #creates the open_channel with all the listed attributes
    open_channel.create()

    #updates open_channel tags
    open_channel.tags = ['tag3', 'tag4']
    open_channel.update(set_tags: true)

.. note::

    Not all of the attributes listed above have to be present to update an open
    channel.

Lookup Open Channel
-------------------
Looking up an open channel is done by passing the channel_id in question to
the lookup method.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    open_channel = UA::OpenChannel.new(client: airship)
    open_channel.lookup(channel_id: 'channel_id')
