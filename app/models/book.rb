class Book
  include ActiveModel::Model

  attr_accessor :title, :authors, :image_url, :rating, :ratings_count

  def self.search(query)
    response = HardcoverApiService.query_books(query)

    books = []
    for book in response["data"]["search"]["results"]["hits"]
      next if !book["document"]["image"]["url"]
      new_book = self.new(
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
