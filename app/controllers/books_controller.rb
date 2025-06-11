class BooksController < ApplicationController
  allow_unauthenticated_access

  def index
    @books = HardcoverApiService.query_books(params[:query])
  rescue HardcoverApiService::ApiError => error
    @books = []
    flash[:alert] = error.message
  end

  def show
    @book = HardcoverApiService.find_book(params[:id])
  rescue HardcoverApiService::ApiError => error
    flash[:alert] = error.message
    redirect_to root_path
  end
end
