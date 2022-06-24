class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  
  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if current_user.author?(question)
      question.update(question_params)
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question deleted'
    else
      redirect_to question, alert: 'Question cannot be deleted'
    end
  end

  private
  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
