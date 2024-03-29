class AnswersController < ApplicationController
  include Liked

  authorize_resource
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[update destroy set_best]
  after_action :publish_answer, only: %i[create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)

    @answer.author = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def set_best
    @question.update(best_answer: answer)
      if @question.reward.present?
        @question.reward.update(answer: answer, user: current_user)
      end

    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  private
  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{answer.question_id}",
      answer: answer
    )
  end

  def find_question
    @question = answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url])
  end
end
