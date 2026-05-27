module Notifications
  class DeliveryService
    def self.call(notification:)
      notification.update!(status: "delivered")
    rescue StandardError
      notification.update!(status: "failed")
    end
  end
end
