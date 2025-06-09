class BooksController < ApplicationController
  require "net/http"
  def index
    uri = URI("https://api.hardcover.app/v1/graphql")
    body = { "query": "query { search(query: \"#{params[:query]}\", query_type: \"Book\", per_page: 20, page: 1, sort: \"users_count: desc\") { results } }" }.to_json
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer #{ENV["HARDCOVER_API_KEY"]}"
    req.body = body
    res = http.request(req)
    parsed = JSON.parse(res.body)

    @books = []
    for book in parsed["data"]["search"]["results"]["hits"]
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
