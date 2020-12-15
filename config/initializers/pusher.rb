Pusher.app_id = Rails.application.credentials.dig(:pusher, :app_id)
Pusher.key = Rails.application.credentials.dig(:pusher, :key)
Pusher.secret = Rails.application.credentials.dig(:pusher, :secret)
Pusher.cluster = Rails.application.credentials.dig(:pusher, :cluster)
Pusher.logger = Rails.logger
Pusher.encrypted = true
