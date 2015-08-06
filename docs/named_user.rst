Named User
==========

Named User Listing
------------------

Named User lists are fetched by instantiating an iterator object
using :rb:class:`NamedUserList`.
For more information, see:
http://docs.urbanairship.com/api/ua.html#listing

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user_list = UA::NamedUserList.new(client: airship)

    named_user_list.each do |named_user|
        puts(named_user)
    end

Association
-----------

Associate a channel with a named user ID. For more information, see:
http://docs.urbanairship.com/api/ua.html#association

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship, named_user_id: 'named_user_id')
    named_user.associate(channel_id: 'channel_id', device_type: 'ios')

.. note::
    You may only associate up to 20 channels to a Named User.

Disassociation
--------------

Remove a channel from the list of associated channels for a named user.
For more information, see:
http://docs.urbanairship.com/api/ua.html#disassociation

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship, named_user_id: 'named_user_id')
    named_user.disassociate(channel_id: 'channel_id', device_type: 'ios')

.. note::
    ``named_user_id`` is an optional parameter in this method since each
    ``channel_id`` can only be associated with one named user.

Lookup
------

Look up a single named user.
For more information, see: http://docs.urbanairship.com/api/ua.html#lookup

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship, named_user_id: 'named_user_id')
    user = named_user.lookup

Tags
----

Add, remove, or set tags on a named user. For more information,
see: http://docs.urbanairship.com/api/ua.html#tags-named-users

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user_tags = UA::NamedUserTags.new(client: airship)
    named_user_ids = ['named_user_id1', 'named_user_id2', 'named_user_id3']
    named_user_tags.set_audience(user_ids: named_user_ids)
    named_user_tags.add(group_name: 'group_name1', tags: ['tag1', 'tag2', 'tag3'])
    named_user_tags.remove(group_name: 'group_name2', tags: 'tag4')
    named_user_tags.send_request

.. note::
    A single request may contain an add or remove field, both, or a single set
    field.
