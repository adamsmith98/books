class HardcoverApiService
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
    JSON.parse(response.body)
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
end
