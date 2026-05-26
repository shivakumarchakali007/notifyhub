module Events
  class CreateService
    def self.call(user:, params:)
      event = Event.create!(
        user: user,
        event_type: params[:event_type],
        payload: params[:payload]
      )

      ProcessEventJob.perform_later(event.id)
      event
    end
  end
end
