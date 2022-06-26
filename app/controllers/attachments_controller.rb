class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    if @attachment.record.author == current_user
      @attachment.purge
      redirect_to @attachment.record
    end
  end
end
