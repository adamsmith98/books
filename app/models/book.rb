class Book
  include ActiveModel::Model

  attr_accessor :title, :authors, :image_url, :rating, :ratings_count
end
