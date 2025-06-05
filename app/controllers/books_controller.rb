class BooksController < ApplicationController
  require "net/http"
  def index
    url = URI("https://www.googleapis.com/books/v1/volumes?q=pride+inauthor:austen&maxResults=40")
    res = Net::HTTP.get(url)
    parsed = JSON.parse(res)
    @books = []
    for book in parsed["items"]
      new_book = {}
      new_book["title"] = book["volumeInfo"]["title"]
      new_book["subtitle"] = book["volumeInfo"]["subtitle"]
      new_book["authors"] = book["volumeInfo"]["authors"]
      new_book["image_url"] = book["volumeInfo"]["imageLinks"]["thumbnail"] if book["volumeInfo"]["imageLinks"]
      new_book["average_rating"] = book["volumeInfo"]["averageRating"]
      new_book["ratings_count"] = book["volumeInfo"]["ratingsCount"]
      new_book["description"] = book["volumeInfo"]["description"]
      @books.append(new_book)
    end
  end
end
