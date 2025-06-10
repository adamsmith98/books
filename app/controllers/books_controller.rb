class BooksController < ApplicationController
  def index
    @books = HardcoverApiService.query_books(params[:query])
  rescue HardcoverApiService::ApiError => error
    @books = []
    flash[:alert] = error.message
  end
end
