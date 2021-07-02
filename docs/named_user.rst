Named User
==========

Named User Listing
------------------

Named User lists are fetched by instantiating an iterator object
using :rb:class:`NamedUserList`.
For more information, see `the API documentation
<http://docs.airship.com/api/ua.html#listing>`__

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

Associate a channel with a named user ID. For more information, see
`the API documentation
<http://docs.airship.com/api/ua.html#association>`__

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'app_or_master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = 'named_user'
    named_user.associate(channel_id: 'channel_id', device_type: 'ios')

.. note::

    Do not include a ``device_type`` for Web and Open platform associations.

Disassociation
--------------

Remove a channel from the list of associated channels for a named user.
For more information, see `the API documentation
<http://docs.airship.com/api/ua.html#disassociation>`__

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'app_or_master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.disassociate(channel_id: 'channel_id', device_type: 'ios')

.. note::

    ``named_user_id`` does not have to be set on the named_user object for this
    method call since ``channel_id`` can only be associated with one named user.
    Do not include a ``device_type`` for Web and Open platform disassociations.

Lookup
------

Look up a single named user.
For more information, see `the API documentation
<http://docs.airship.com/api/ua.html#lookup>`__

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = 'named_user'
    user = named_user.lookup

Tags
----

Add, remove, or set tags on a named user. For more information,
see `the API documentation
<http://docs.airship.com/api/ua.html#tags-named-users>`__

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

Attributes
----------

Set or remove attributes on a named user. For more information, see `the API documentation
https://docs.airship.com/api/ua/#operation-api-named_users-named_user_id-attributes-post>`__

.. code-block:: ruby

  require 'urbanairship'
  airship = Urbanairship::Client.new(key: 'application_key', secret: 'master_secret')
  named_user = Urbanairship::NamedUser.new(client: airship)
  named_user.named_user_id = 'named_user'
  named_user.update_attributes(attributes: [
      { action: 'set', key: 'first_name', value: 'Firstname' },
      { action: 'remove', key: 'nickname' },
      { action: 'set', key: 'last_name', value: 'Lastname', timestamp: Time.now.utc }
  ])

.. note::

    Timestamp is optional, if missing it will default to 'now'.
