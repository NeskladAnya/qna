module Subscribed
  extend ActiveSupport::Concern

  included do
    authorize_resource
    before_action :set_subscribable, only: %i[subscribe unsubscribe]
  end

  def subscribe
    @subscribable.add_subscription(current_user)
    redirect_to @subscribable
  end

  def unsubscribe
    @subscribable.remove_subscription(current_user)
    redirect_to @subscribable
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end
end
