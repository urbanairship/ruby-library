#################
Channel Uninstall
#################

Channels can be uninstalled using ``ChannelUninstall``. There is a limit of 200 channels that
can be uninstalled at one time. For more information, see `the API documentation
<http://docs.urbanairship.com/api/ua.html#uninstall-channels>`__.

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'app_key', secret: 'master_secret')
   cu = UA::ChannelUninstall.new(client: airship)

   chans = [{"channel_id" => "00000000-00000000-00000000-00000000",
             "device_type" => "ios"},
            {"channel_id" => "11111111-11111111-11111111-11111111",
             "device_type" => "android"}]

   cu.uninstall(channels: chans)
