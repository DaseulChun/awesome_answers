class QuestionSerializer < ActiveModel::Serializer
  # This file was generated with:
  # rails g serializer question

  # ActiveModel::Serializer Docs:
  # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/README.md

  # Use the `attributes` method to specifiy which methods
  # of a model to include in the serialization output.
  # All columns of a model have a corresponding getter method
  # therefore we can filter this way as well.
  attributes(:id, :title, :body, :created_at, :updated_at, :like_count)

  # To include associated models
    # for creating asscoations.
    # You can rename the association, with 'key'. This will only affect the rendered json.
  belongs_to :user, key: :author
  has_many :answers

  # You can create custom methods inside a serializer to 
  # include custom data in the json serialization.
  # doing so, make sure to include the name in the attriutes call
  def like_count
    # `object` will refer to the instance of the model being serialized
    # Use it where you would use `self` in the model class.
    object.likes.count  
  end

  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at
  end
end
