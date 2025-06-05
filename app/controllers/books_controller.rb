class BooksController < ApplicationController
  require "net/http"
  def index
    url = URI("https://www.googleapis.com/books/v1/volumes/s1gVAAAAYAAJ")
    res = Net::HTTP.get(url)
    parsed = JSON.parse(res)
    @title = parsed["volumeInfo"]["title"]
    @subtitle = parsed["volumeInfo"]["subtitle"]
    @authors = parsed["volumeInfo"]["authors"]
    @image_url = parsed["volumeInfo"]["imageLinks"]["thumbnail"]
    @average_rating = parsed["volumeInfo"]["averageRating"]
    @ratings_count = parsed["volumeInfo"]["ratingsCount"]
    @description = parsed["volumeInfo"]["description"]
  end
end
