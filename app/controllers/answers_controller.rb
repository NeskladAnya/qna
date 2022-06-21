class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)

    @answer.author = current_user
    if @answer.save
      redirect_to question_path(@question), notice: 'Answer added'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer deleted'
    else
      redirect_to @answer.question, alert: 'Answer cannot be deleted'
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end
