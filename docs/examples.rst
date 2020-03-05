Examples
========

Common setup:

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key: 'app_key', secret: 'master_secret')


Simple broadcast to all devices
-------------------------------

.. code-block:: ruby

    push = airship.create_push
    push.audience = UA.all
    push.notification = UA.notification(alert: "Hello, world!")
    push.device_types = UA.all
    push.send_push


Complex audience with platform specifics
---------------------------------------------

.. code-block:: ruby

    push = airship.create_push
    push.audience = UA.and(
        UA.tag("breakingnews"),
        UA.or(
            UA.tag("sports"),
            UA.tag("worldnews")
        )
    )
    push.notification = UA.notification(
        ios: UA.ios(
            alert: "Serena Williams wins U.S. Open",
            badge: "+1",
            extra: {"articleid" => "123456"}
        ),
        android: UA.android(
            alert: "Breaking Android News! Serena Williams wins U.S. Open!",
            extra: {"articleid" => "http://m.example.com/123456"}
        ),
        amazon: UA.amazon(
            alert: 'Breaking Amazon News!',
            expires_after: 60,
            extra: {'articleid' => '12345'},
            summary: 'This is a short message summary',
        )
    )
    push.device_types = UA.device_types(['ios', 'android', 'amazon'])
    push.send_push


Single iOS push
---------------

.. code-block:: ruby

    push = airship.create_push
    push.audience = UA.ios_channel('channel-id')
    push.notification = UA.notification(
       ios: UA.ios(alert="Soledad O'Brien is following you on Twitter")
    )
    push.device_types = UA.device_types(['ios'])
    push.send_push


Single iOS Rich Push with notification
--------------------------------------

.. code-block:: ruby

    push = airship.create_push
    push.audience = UA.ios_channel('channel-id')
    push.notification = UA.notification(
       ios: UA.ios(alert="Soledad O'Brien is following you on Twitter")
    )
    push.device_types = UA.device_types(['ios'])
    push.message = UA.message(title: "New follower", body: "<h1>Say hello!</h1>")
    push.send_push


Rich Push with extra and without notification
---------------------------------------------

.. code-block:: ruby

    push = airship.create_push
    push.audience = UA.all
    push.device_types = UA.all
    push.message = UA.message(
      title: "New follower",
      body: "<h1>Say hello to your new follower!</h1>",
      extra: {"articleid" => "http://m.example.com/123456"}
    )
    push.send_push


Scheduled iOS Push
------------------

.. code-block:: ruby

    sched = airship.create_scheduled_push
    sched.schedule = UA.scheduled_time(Time.now.utc + 60)

    sched.push = airship.create_push
    sched.push.audience = UA.ios_channel('channel-id')
    sched.push.notification = UA.notification(
       ios: UA.ios(alert: "Soledad O'Brien is following you on Twitter"))
    sched.push.device_types = UA.device_types(['ios'])

    sched.send_push