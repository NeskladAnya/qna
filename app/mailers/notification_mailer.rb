class NotificationMailer < ApplicationMailer
  def subscribe_question(user, answer)
    @question = answer.question
    @answer = answer

    mail to: user.email, subject: "New answer to the question '#{@question.title}'"
  end
end
