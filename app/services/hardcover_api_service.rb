class HardcoverApiService
  class ApiError < StandardError; end
  require "net/http"

  BASE_URI = URI("https://api.hardcover.app/v1/graphql")

  def self.query_books(query)
    http = Net::HTTP.new(BASE_URI.host, BASE_URI.port)
    http.use_ssl = true if BASE_URI.scheme == "https"

    request = Net::HTTP::Post.new(BASE_URI)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["HARDCOVER_API_KEY"]}"
    request.body = book_query(query)

    response = http.request(request)
    case response
    when Net::HTTPSuccess
      extract_books(JSON.parse(response.body))
    else
      raise ApiError, "Error: #{response.code} #{response.message}"
    end
  rescue SocketError, Timeout::Error => error
    raise ApiError, "Network error: #{error.message}"
  end

  private

  def self.book_query(query)
    {
      "query": <<~TEXT
        query {
          search(
            query: "#{query}",
            query_type: "Book",
            per_page: 20,
            page: 1,
            sort: "users_count: desc"
          ) {
            results
          }
        }
      TEXT
    }.to_json
  end

  def self.extract_books(response)
    books = []
    for book in response["data"]["search"]["results"]["hits"]
      next if !book["document"]["image"]["url"]
      new_book = Book.new(
        title: book["document"]["title"],
        authors: book["document"]["author_names"],
        image_url: book["document"]["image"]["url"],
        rating: book["document"]["rating"],
        ratings_count: book["document"]["ratings_count"]
      )
      books.append(new_book)
    end
    books
  end
end
