class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "SIDEKIQ WORKING"
  end
end
