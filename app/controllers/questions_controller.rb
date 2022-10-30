class QuestionsController < ApplicationController
  include Liked
  include Commented

  authorize_resource
  
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
    gon.current_user_id = current_user&.id
  end

  def show
    @answer = question.answers.new

    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer_id)

    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
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
    question.update(question_params)
  end

  def destroy
    if question.destroy
      redirect_to questions_path, notice: 'Question deleted'
    else
      redirect_to question, alert: 'Question cannot be deleted'
    end
  end

  private
  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                     files: [], reward_attributes: [:name, :image],
                                     links_attributes: [:id, :name, :url])
  end
end
