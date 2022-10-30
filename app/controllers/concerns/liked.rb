module Liked
  extend ActiveSupport::Concern

  included do
    before_action :set_likeable, only: %i[like dislike render_json]
  end

  def like
    if @likeable.already_liked?(current_user)
      @likeable.clear_rating(current_user)
    else
      @likeable.clear_rating(current_user)
      @likeable.like(current_user)
    end
    render_json
  end

  def dislike
    if @likeable.already_disliked?(current_user)
      @likeable.clear_rating(current_user)
    else
      @likeable.clear_rating(current_user)
      @likeable.dislike(current_user)
    end
    render_json
  end

  private

  def render_json
    respond_to do |format|
      if @likeable.save
        format.json do
          render json: { id: @likeable.id, resource: @likeable.class.name.underscore,
                         liked: @likeable.already_liked?(current_user),
                         disliked: @likeable.already_disliked?(current_user),
                         final_rating: @likeable.final_rating }
        end
      else
        format.json do
          render json: @likeable.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_likeable
    @likeable = model_klass.find(params[:id])
  end
end
