Attributes
==========

Set Attribute for a Channel
---------------------------

The following will set an attribute for a given channel ID.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'app_key', secret:'secret_key')
    channel_info = UA::ChannelInfo.new(client: airship)
    channel_info.audience = {"ios_channel": "b8f9b663-0a3b-cf45-587a-be880946e881"}
    channel_info.attributes =  {
        "action": "set",
        "key": "favorite_food",
        "value": "cake"
    }
    channel_info.set_attributes

.. note::

    This should return a 200 response

Send Push to Audience with Attribute Specifications
---------------------------------------------------

This will send a push to an audience who meet the specifications of attribute we
set  here. This example is using a text attribute where we are looking for audience
members whose favorite food includes pineapple.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'app_key', secret:'secret_key')
    new_attribute = UA::Attribute.new(client: airship)
    new_attribute.attribute = 'favorite_food'
    new_attribute.operator = 'contains'
    new_attribute.value = 'pineapple'
    push = airship.create_push
    push.audience = new_attribute.payload
    push.notification = UA.notification(alert: 'Hello')
    push.device_types = ['android', 'ios', 'web']
    push.send_push

.. note::

    This should return a 202 response