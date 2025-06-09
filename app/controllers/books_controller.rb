class BooksController < ApplicationController
  def index
    @books = Book.search(params[:query])
  end
end
