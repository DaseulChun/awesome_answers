class Answer < ApplicationRecord
  # this was created using rails g model answer body:text question:references
  belongs_to :user
  belongs_to :question
  validates :body, presence: true
end
