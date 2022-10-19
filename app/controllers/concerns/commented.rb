module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[create_comment render_json]
    after_action :broadcast_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params)
    render_json
  end

  private
  def comment_params
    params.require(:comment).permit(:body).merge(author: current_user)
  end

  def render_json
    respond_to do |format|
      if @commentable.save
        format.json do
          render json: { id: @commentable.id, resource: @commentable.class.name.underscore,
                         body: @commentable.body }
        end
      else
        format.json do
          render json: @commentable.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def broadcast_comment
    return if @comment.errors.any?

    question_id = @comment.commentable_type == 'Question' ? @comment.commentable_id : @comment.commentable.question_id

    ActionCable.server.broadcast("question/#{question_id}", data: {
      type: @comment.commentable_type.downcase,
      id: @comment.commentable_id,
      body: @comment.body,
      author: @comment.author
    })
  end
end
