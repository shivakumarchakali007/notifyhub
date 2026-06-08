module Notifications
  class FetchService
    def self.call(user:)
      Notification.where(user: user)
    end
  end
end
