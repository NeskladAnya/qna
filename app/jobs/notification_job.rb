class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Notification.send_notification(answer)
  end
end
