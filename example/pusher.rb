class Pusher

	require 'urbanairship'
	UA = Urbanairship

	def send_broadcast_message
		airship = UA::Client.new(key:'app_key', secret:'master_secret')
		p = airship.create_push
		p.audience = UA.all
		p.notification = UA.notification(alert: 'Hello')
		p.device_types = UA.device_types(['ios','android'])
		p.send_push
	end

end

Pusher.new.send_broadcast_message