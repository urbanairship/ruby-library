Tags
====

This reference covers tag operations on channels.

For more information, see: http://docs.urbanairship.com/api/ua.html#tags.


ChannelTags
-----------
Allows the addition, removal, and setting of tags on a channel specified by
the required audience field.

A single request body may contain an add or remove
field, or both, or a single set field. If both add and remove are fields are
present and the intersection of the tags in these fields is not empty, then
a 400 will be returned.

Tag set operations only update tag groups that are present in the request.
Tags for a given Tag Group can be cleared by sending a set field with an empty
list.

If a tag update request contains tags in multiple Tag Groups, the request
will be accepted if at least one of the Tag Groups is active. If inactive or
missing Tag Groups are specified, a warning will be included in the response.

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship(app_key, master_secret)
    channel_tags = ua.devices.ChannelTags(airship)
    ios_audience = ['channel1', 'channel2', 'channel3']
    android_audience = 'channel4'
    amazon_audience = None
    channel_tags.set_audience(ios_audience, android_audience, amazon_audience)
    channel_tags.add('group_name', ['tag1', 'tag2', 'tag3'])
    channel_tags.remove('group_name', 'tag4')
    channel_tags.send_request()

.. automodule:: urbanairship.devices.tag
    :members: ChannelTags
    :noindex:

.. note::
    The audience can be either a single channel or as a list of channels. Similarly,
    the tags can either be set as a single tag or a list of tags.


Legacy Tags
-----------
The following commands have been deprecated.

Tag Listing
^^^^^^^^^^^
Lists tags that exist for this application. Tag Listing will return
up to the first 100 tags per application.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   list_tags = ua.TagList(airship)
   list_tags.list_tags()

.. automodule:: urbanairship.devices.tag
   :members: TagList
   :noindex:


Adding Devices to a Tag
^^^^^^^^^^^^^^^^^^^^^^^
Add one or more channels to a particular tag. For more information, see
`documentation on adding and removing devices from a tag <adding>`_.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   devices = ua.Tag(airship, 'working_tag')
   devices.add(
       ios_channels=['ios_channel_id'],
       android_channels=['android_channel_id', 'android_channel_id_2']
   )

.. automodule:: urbanairship.devices.tag
   :members: Tag
   :noindex:


Removing Devices from a Tag
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Remove one or more channels from a particular tag. For more information,
see: `documentation on adding and removing devices from a tag <adding>`_.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   devices = ua.Tag(airship, 'working_tag')
   devices.remove(
       ios_channels=['ios_channel_id'],
       android_channels=['android_channel_id', 'android_channel_id_2']
   )

.. automodule:: urbanairship.devices.tag
   :members: Tag
   :noindex:

Deleting a Tag
^^^^^^^^^^^^^^
A tag can be removed from our system by issuing a delete. This will
remove the master record of the tag. For more information, see:
`documentation on deleting a tag <deleting>`_.

Note:
    Delete will remove the tag from all devices with the exception of
    devices that are inactive due to uninstall. Devices that were
    uninstalled will retain their tags.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   delete_tag = ua.DeleteTag(airship, 'tag_to_delete')
   delete_tag.send_delete()

.. automodule:: urbanairship.devices.tag
   :members: DeleteTag
   :noindex:


Batch Modification of Tags
^^^^^^^^^^^^^^^^^^^^^^^^^^
Modify the tags for a number of device channels. For more information,
see: `documentation on batch modification of tags <batch>`_.

Note:
    You must include an object containing an ios_channel,
    android_channel, or amazon_channel, and a list of tags
    to apply.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)
   send_batch = ua.BatchTag(airship)
   send_batch.add_ios_channel('ios_channel_id', ['ios_tag', 'portland_OR'])
   send_batch.add_android_channel('android_channel_id', ['tag11', 'tag12'])
   send_batch.add_amazon_channel(
       'amazon_channel_id', ['tag11', 'portland_OR']
   )
   send_batch.send_request()

.. automodule:: urbanairship.devices.tag
   :members: BatchTag
   :noindex:


.. _adding: http://docs.urbanairship.com/api/ua.html#adding-and-removing-devices-from-a-tag
.. _removing: http://docs.urbanairship.com/api/ua.html#adding-and-removing-devices-from-a-tag
.. _deleting: http://docs.urbanairship.com/api/ua.html#deleting-a-tag
.. _batch: http://docs.urbanairship.com/api/ua.html#batch-modification-of-tags
