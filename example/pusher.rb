class Pusher

	require 'urbanairship'
	UA = Urbanairship

	def send_message
		airship = UA::Client.new(key:'app_key', secret:'master_secret')
		p = airship.create_push
		p.audience = UA.all
		p.notification = UA.notification(alert: 'Hello')
		p.device_types = UA.all
		p.in_app = UA.in_app(
				alert: 'This is a test message!',
				display_type: 'banner'
				)
		p.send_push
	end

end

Pusher.new.send_message