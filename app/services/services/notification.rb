class Services::Notification
  def send_notification(answer)
    subscriptions = answer.question.subscriptions

    subscriptions.find_each |subscription| do
      if subscription.created_at <= answer.created_at
        NotificationMailer.subscribe_question(subscription.user, answer).deliver_later
      end
    end
  end
end
