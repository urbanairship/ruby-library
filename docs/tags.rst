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

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    channel_tags = UA::ChannelTags.new(client: airship)
    ios_audience = ['channel1', 'channel2', 'channel3']
    android_audience = 'channel4'
    amazon_audience = nil
    channel_tags.set_audience(
        ios: ios_audience,
        android: android_audience,
        amazon: amazon_audience
    )
    channel_tags.add(group_name: 'group_name', tags: ['tag1', 'tag2', 'tag3'])
    channel_tags.remove(group_name: 'group_name', tags: 'tag4')
    channel_tags.send_request

.. note::

    The audience can be either a single channel or a list of channels. Similarly,
    the tags can either be set as a single tag or a list of tags.
