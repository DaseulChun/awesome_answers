class Like < ApplicationRecord
  # makes us able to use convenience method (access to read, create etc.)
  # relation is already made in the db when we ran migration
  belongs_to :user
  belongs_to :question


  validates(
   :question_id, 
   uniqueness: { 
     scope: :user_id, 
     message: "has already been liked"
    }
  )
  
  # The above will ensure that the question_id / user_id
  # combination is unique. This is needed to ensure each user 
  # can only like a question once. 
end
