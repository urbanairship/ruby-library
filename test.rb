require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'r3NH_77RQgynljLkv9K5oQ', secret:'Sh7fbMpNTF213_hc2ZXiSA')
override = UA::MmsNotification.new(client: airship)
override.template_id = "883a7e16-1182-4c15-8cbe-06deec44ca16"
override.shorten_links = true
override.content_length = 19309
override.content_type = "image/jpeg"
override.url = "https://images-na.ssl-images-amazon.com/images/I/71eUHxwlMKL._AC_SX425_.jpg"
mms_notification = override.mms_template_with_id
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
  "ua_msisdn": "19703266269",
  "ua_sender": "81709",
  "ua_opted_in": "2020-01-30T18:45:30",
  "customer": {
            "first_name": "Sarah",
            "last_name": "Kirk",
            "animal": "Dogs"
        }
  }
]
send_it.device_types = [ "mms" ]
send_it.notification = mms_notification
send_it.create_and_send

#send_it.payload
{:audience=>{:create_and_send=>[{:ua_msisdn=>"19703266269", :ua_sender=>"81709", :ua_opted_in=>"2020-01-30T18:45:30", :delivery_image=>"https://i.imgur.com/ZZmrhTH.gif", :customer=>{:first_name=>"Sarah", :last_name=>"Kirk", :animal=>"Dogs"}}]}, :device_types=>["mms"], :notification=>{:mms=>{:template=>{:template_id=>"883a7e16-1182-4c15-8cbe-06deec44ca16"}}}, :campaigns=>{:categories=>["winter sale", "west coast"]}}

#curl without slides object
curl https://go.urbanairship.com/api/create-and-send/ -X POST -u "r3NH_77RQgynljLkv9K5oQ:Sh7fbMpNTF213_hc2ZXiSA" -d "{\"audience\":{\"create_and_send\":[{\"ua_msisdn\":\"19703266269\",\"ua_sender\":\"81709\",\"ua_opted_in\":\"2020-01-30T18:45:30\",\"delivery_image\":\"https://i.imgur.com/ZZmrhTH.gif\",\"customer\":{\"first_name\":\"Sarah\",\"last_name\":\"Kirk\",\"animal\":\"Dogs\"}}]},\"device_types\":[\"mms\"],\"notification\":{\"mms\":{\"template\":{\"template_id\":\"883a7e16-1182-4c15-8cbe-06deec44ca16\"}}},\"campaigns\":{\"categories\":[\"winter sale\",\"west coast\"]}}"

#curl with slides object
curl https://go.urbanairship.com/api/create-and-send/ -X POST -u "r3NH_77RQgynljLkv9K5oQ:Sh7fbMpNTF213_hc2ZXiSA" -d "{\"audience\":{\"create_and_send\":[{\"ua_msisdn\":\"19703266269\",\"ua_sender\":\"81709\",\"ua_opted_in\":\"2020-01-30T18:45:30\",\"customer\":{\"first_name\":\"Sarah\",\"last_name\":\"Kirk\",\"animal\":\"Dogs\"}}]},\"device_types\":[\"mms\"],\"notification\":{\"mms\":{\"template\":{\"template_id\":\"883a7e16-1182-4c15-8cbe-06deec44ca16\",\"slides\":[{\"media\":\"https://i.imgur.com/ZZmrhTH.gif\"}]}}}}"
