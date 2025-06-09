class BooksController < ApplicationController
  def index
    response = HardcoverApiService.query_books(params[:query])

    @books = []
    for book in response["data"]["search"]["results"]["hits"]
      next if !book["document"]["image"]["url"]
      new_book = {}
      new_book["title"] = book["document"]["title"]
      new_book["authors"] = book["document"]["author_names"]
      new_book["image_url"] = book["document"]["image"]["url"]
      new_book["average_rating"] = book["document"]["rating"]
      new_book["ratings_count"] = book["document"]["ratings_count"]
      @books.append(new_book)
    end
  end
end
