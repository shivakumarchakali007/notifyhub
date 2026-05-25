class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true
  validates :channel, presence: true
  validates :status, presence: true

  validates :channel, uniqueness: { scope: [ :user_id, :event_id ] }
end
