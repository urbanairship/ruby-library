class Pusher

	require 'urbanairship'
	UA = Urbanairship

	def send_message
		airship = UA::Client.new(key:'CxEeUYM6TqCEAY9FaVHTVw', secret:'g9JW4M4uRLmWUoaM-mZE6g')
		p = airship.create_push
		p.audience = UA.all
		p.notification = UA.notification(alert: 'Hello')
		p.device_types = UA.all
		p.in_app = UA.in_app(
				alert: 'it is I, Jenn',
				display_type: 'banner'
				)
		p.send_push
	end

end

Pusher.new.send_message