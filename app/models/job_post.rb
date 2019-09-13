class JobPost < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true 

  def self.search(query)
    where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  end
  # is equivalent to:
  
  # below is in order :
  # name of the scope
  # and a lambda
  # scope(:search, -> (query) {
  #   where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  # })
end
