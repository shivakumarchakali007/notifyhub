class ProcessEventJob < ApplicationJob
  queue_as :default

  retry_on StandardError,
           wait: 5.seconds,
           attempts: 3

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
