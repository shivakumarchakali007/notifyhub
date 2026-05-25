module Events
  class CreateService
    def self.call(user:, params:)
      Event.create!(
        user: user,
        event_type: params[:event_type],
        payload: params[:payload]
      )
    end
  end
end
