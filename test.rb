require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
open_channel_notification = UA::OpenChannel.new(client:airship)
open_channel_notification.open_platform = 'yakitori'
open_channel_notification.alert = 'a longer alert for users of smart fridges, who have more space.'
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
{
    "ua_address": "mackw2_test",
}
]
send_it.device_types = [ 'open::yakitori' ]
send_it.notification = open_channel_notification.open_channel_override
send_it.create_and_send

<Urbanairship::Devices::CreateAndSend:0x00007fa8b6519d78 @client=#<Urbanairship::Client:0x00007fa8b646d938 @key="ISex_TTJRuarzs9-o_Gkhg", @secret="bF-7RuUzTxy0VzbHLu5mkQ">, @addresses=[{:ua_address=>"mackw2_test"}], @device_types=["open::yakitori"], @notification=#<Urbanairship::Devices::OpenChannel:0x00007fa8b6494e98 @client=#<Urbanairship::Client:0x00007fa8b646d938 @key="ISex_TTJRuarzs9-o_Gkhg", @secret="bF-7RuUzTxy0VzbHLu5mkQ">, @open_platform="yakitori", @alert="a longer alert for users of smart fridges, who have more space.">>