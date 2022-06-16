class AnswersController < ApplicationController
  before_action :find_question

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer added'
    else
      redirect_to @question
    end
  end

  private
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
