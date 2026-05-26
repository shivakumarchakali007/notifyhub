class ProcessEventJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find_by(id: event_id)

    return unless event

    notification = Notification.create!(
      user: event.user,
      event: event,
      channel: "in_app"
    )

    Notifications::DeliveryService.call(notification: notification)
  end
end
