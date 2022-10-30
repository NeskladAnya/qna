class LinksController < ApplicationController
  authorize_resource
  
  def destroy
    @link = Link.find(params[:id])

    @link.destroy
  end
end
