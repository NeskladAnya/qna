class ApplicationController < ActionController::Base
  before_action :set_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private
  def set_user
    gon.user_id = current_user&.id
  end
end
