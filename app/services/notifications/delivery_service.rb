module Notifications
  class DeliveryService
    def self.call(notification:)
      deliver(notification)
      notification.update!(status: "delivered")
    rescue StandardError
      notification.update!(status: "failed")
      raise
    end

    def self.deliver(notification)
      payload = notification.event.payload
      if payload["simulate_failure"]
        raise StandardError, "Delivery Failed"
      end
    end
  end
end
