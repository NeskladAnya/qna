class SearchController < ApplicationController
  skip_authorization_check
  
  def search
    search_base = option == 'global' ? ThinkingSphinx : option.capitalize.constantize

    @result = search_base.search context
  end

  private

  def option
    params[:option]
  end

  def context
    ThinkingSphinx::Query.escape(params[:context])
  end
end
