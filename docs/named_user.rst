Named User
==========

Named User Listing
------------------

Named User lists are fetched by instantiating an iterator object
using :rb:class:`NamedUserList`.
For more information, see `the API documentation
<http://docs.urbanairship.com/api/ua.html#listing>`__

.. code-block:: ruby

    require 'urbanairship'
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user_list = UA::NamedUserList.new(client: airship)

    named_user_list.each do |named_user|
        puts(named_user)
    end

Association
-----------

Associate a channel with a named user ID. For more information, see
`the API documentation
<http://docs.urbanairship.com/api/ua.html#association>`__

.. code-block:: ruby

    require 'urbanairship'
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = 'named_user'
    named_user.associate(channel_id: 'channel_id', device_type: 'ios')

.. note::

    You may only associate up to 20 channels to a Named User.

Disassociation
--------------

Remove a channel from the list of associated channels for a named user.
For more information, see `the API documentation
<http://docs.urbanairship.com/api/ua.html#disassociation>`__

.. code-block:: ruby

    require 'urbanairship'
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.disassociate(channel_id: 'channel_id', device_type: 'ios')

.. note::

    ``named_user_id`` does not have to be set on the named_user object for this
    method call since ``channel_id`` can only be associated with one named user.

Lookup
------

Look up a single named user.
For more information, see `the API documentation
<http://docs.urbanairship.com/api/ua.html#lookup>`__

.. code-block:: ruby

    require 'urbanairship'
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = 'named_user'
    user = named_user.lookup

Tags
----

Add, remove, or set tags on a named user. For more information,
see `the API documentation
<http://docs.urbanairship.com/api/ua.html#tags-named-users>`__

.. code-block:: ruby

    require 'urbanairship'
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
