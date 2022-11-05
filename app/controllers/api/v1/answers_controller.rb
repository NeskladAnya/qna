class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[show update destroy]
  before_action :set_question, only: %i[index show create]

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params.merge(question_id: params[:question_id]))

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, links_attributes: %i[name url id])
  end
end
