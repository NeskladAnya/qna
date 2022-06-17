class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer added'
    else
      redirect_to @question
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    redirect_to @answer.question, notice: 'Answer deleted'
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end
