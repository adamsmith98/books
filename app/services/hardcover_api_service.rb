class HardcoverApiService
  class ApiError < StandardError; end
  require "net/http"

  BASE_URI = URI("https://api.hardcover.app/v1/graphql")

  def self.query_books(query)
    response = send_request(book_query(query))
    extract_books(response["data"]["search"]["results"]["hits"])
  end

  def self.find_book(id)
    response = send_request(find_by_id(id))
    if !response["data"] or !response["data"]["books"][0]
      raise ApiError, "Error: book not found"
    end
    extract_book(response["data"]["books"][0])
  end

  private

  def self.send_request(body)
    http = Net::HTTP.new(BASE_URI.host, BASE_URI.port)
    http.use_ssl = true if BASE_URI.scheme == "https"

    request = Net::HTTP::Post.new(BASE_URI)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["HARDCOVER_API_KEY"]}"
    request.body = body

    response = http.request(request)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise ApiError, "Error: #{response.code} #{response.message}"
    end
  rescue SocketError, Timeout::Error => error
    raise ApiError, "Network error: #{error.message}"
  end

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

  def self.find_by_id(id)
    {
      "query": <<~TEXT
        query {
          books(where: {id: {_eq: #{id}}}) {
            id
            title
            description
            rating
            ratings_count
            image {
              url
            }
            contributions {
              author {
                  name
              }
            }
          }
        }
      TEXT
    }.to_json
  end

  def self.extract_books(books)
    extracted_books = []
    for book in books
      extracted_books.append(extract_book(book["document"]))
    end
    extracted_books
  end

  def self.extract_book(book)
      Book.new(
        id: book["id"],
        title: book["title"],
        description: book["description"],
        author: book["contributions"][0]["author"]["name"],
        image_url: book["image"]["url"],
        rating: book["rating"],
        ratings_count: book["ratings_count"]
      )
  end
end
