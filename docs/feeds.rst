Feeds
=====

The Feed API is used to add and remove RSS or Atom feeds used to trigger push notifications.
For more information, see `the API documentation on feeds
<http://docs.urbanairship.com/api/ua.html#feeds>`_

Create
------

To create a new feed, you need the url of the feed and a push object to execute when the feed
is updated.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    push = airship.create_push
    push.audience = UA.all
    push.notification = UA.notification(alert: 'Hello')
    push.device_types = UA.all
    feed = UA::Feed.new(client: airship)
    resp = feed.create(url: 'feed url', push: push)
    puts(resp)


Lookup
------

For details on a particular feed, you need the feed id:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    feed = UA::Feed.new(client: airship)
    resp = feed.lookup(feed_id: 'feed_id')
    puts(resp)


Update
------

To update a feed, you need the feed id, the url of the feed, and a push object
containing the update.

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    push = airship.create_push
    push.audience = UA.all
    push.notification = UA.notification(alert: 'Updated!')
    push.device_types = UA.all
    feed = UA::Feed.new(client: airship)
    resp = feed.lookup(feed_id: 'feed_id', url: 'feed url', push: push)
    puts(resp)


Delete
------

To delete a feed, you need the feed id:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    feed = UA::Feed.new(client: airship)
    resp = feed.delete(feed_id: 'feed id')
    puts(resp)
