class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)

    @answer.author = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.destroy
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end
