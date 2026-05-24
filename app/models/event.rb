class Event < ApplicationRecord
  belongs_to :user

  validates :event_type, presence: true
  validates :payload, presence: true
end
