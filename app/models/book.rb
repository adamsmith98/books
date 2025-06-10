class Book
  include ActiveModel::Model

  attr_accessor :id, :title, :description, :author, :image_url, :rating, :ratings_count
end
