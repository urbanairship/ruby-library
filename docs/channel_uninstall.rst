Channel Uninstall
=================

Uninstalling Channels
---------------------
Channels can be uninstalled using :py:class:`ChannelUninstall`.
There is a limit of 200 channels that can be uninstalled at one time.
For more information, see:
http://docs.urbanairship.com/api/ua.html#uninstall-channels

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    cu = ua.ChannelUninstall(airship)

    chans = [{"channel_id": "00000000-00000000-00000000-00000000",
              "device_type": "ios"},
              {"channel_id": "11111111-11111111-11111111-11111111",
              "device_type": "android"}]

    cu.uninstall(chans)

.. automodule:: urbanairship.devices.channel_uninstall