module Notifications
  class DeliveryService
    def self.call(notification:)
      notification.update!(status: "delivered")
    end
  end
end
