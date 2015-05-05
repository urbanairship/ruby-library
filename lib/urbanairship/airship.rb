module Urbanairship
	class Airship
		def initialize(key:, secret:)
		end

		def send_request(method:, body:, url:, content_type:, version:)
			fail "Not implemented yet."
		end

		def create_push
			Push.new(self)
		end

		def create_scheduled_push
			ScheduledPush.new(self)
		end
	end
end
