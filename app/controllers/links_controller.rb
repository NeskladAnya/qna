class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])

    if current_user.author?(@link.linkable)
      @link.destroy
    end
  end
end
