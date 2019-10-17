class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :likes, dependent: :destroy
  # The 'has_many' below depends on the existence of
  # 'has_many :likes' above. If the above doesn't exist,
  # you will get an error. If the one above comes after,
  # you will also get an error.
  # has_many :users, through: :likes
  # we could've wrote like above, 👆
  # we don't need to write like this (coz no confliction with existing association)
  # but to make it more clear and readability, we can write like this 👇
  has_many :likers, through: :likes, source: :user
  
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings#, source: :tag
  # If the name of the association (i.e. tags) is the same as
  # the source singularized (i.e. tag) then the source can
  # be omitted

  has_one_attached :image
  # dependent option: 
  # 1) nullify : if question is deleted, question ID will be null, but answer will be left
  # 2) destroy : if question is deleted, all the answers will be deleted


  # This is the Question model. We generated this file
  # with the command:
  # rails generate model question title:string body:text
  # Or in general:
  # rails generate model ModelName ColumnOneName:ColumnOneType ColumnTwoName:ColumnTwoType


  # This command also generates a migration file in
  # db/migrate

  # Rail will add attr_accessors for all columns of the table (i.e. id, title, body, created_at, updated_at)

  # Create validations by using the `validates` method.
  # The arguments are (in order):
  # - A column name as a symbol
  # - Named arguments corresponding to validation rules

  # To read more on validations, go to the following guide:
  # https://guides.rubyonrails.org/active_record_validations.html

  validates(:title, presence: true, uniqueness: true)

  validates(
    :body,
    presence: {
        message: "must exist"
      },
      length: { minimum: 10 }
      )

      validates :view_count, numericality: {
        greater_than_or_equal_to: 0
        # lesser_than:
        # greater_than:
      }#, allow_nil: true
      # Custom Validation
      # Be careful, the method for custom validations is
      # singular and its almost exactly same the method
      # for regular validations.
      validate :no_monkey

      # `before_validation` is a lifecycle callback method that allows us
      # to respond to events during the life a model instance (e.g. being validated,
      # being created, being updated, etc)
      # All lifecycle callback methods take a symbol named after a method
      # and calls that method at the appropriate time.
      before_validation :set_default_view_count

      # Create a scope with a class method
      # https://guides.rubyonrails.org/active_record_querying.html#scopes
      # def self.recent
      #   order(created_at: :desc).limit(10)
      # end

      # Scopes are such a commonly used feature that there's a way to
      # create them quicker. It takes a name and a lambda as a callback.

      scope :recent, -> { order(created_at: :desc).limit(10)}

      def tag_names
        self.tags.map{ |t| t.name }.join(", ")
      end

      # Appending an '=' to the end of a method name, 
      # allows us to implement a 'setter'.
      # A setter is method that is assignable. 

      # Example
      # q.tag_names = "stuff, yo"

      # The code in the example above would call the method
      # 'tag_names' where the value on the right hand side of the 
      # '=' would become the argument to the method. 

      # This is similar to adding an attr_writer.
      # Setter
      def tag_names=(rhs)
        self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
          # Finds the first record with the given attribute(s),
          # or initializes a record(Tag.new) with the attributes
          # If one is not found
          Tag.find_or_initialize_by(name: tag_name)
        end
      end

      private
      # We could also set a default at the db level
      def set_default_view_count
        # If you are writing to an attribute accessor, you
        # must prefix with `self.` which do not have to do
        # if you're just reading it instead.
        # self.view_count = 0 if self.view_count.nil?
        # self.view_count = self.view_count || 0
        # 👇 is syntax sugar for 👆
        self.view_count ||= 0

      end

      def no_monkey
        # &. is the safe navigation operator. It's used
        # like the . operator to call methods on an object.
        # If the method doesn't exist for the object, `nil`
        # will be returned instead of getting an error.
        if body&.downcase&.include?("monkey")
          # To make a record invalid, you must add a validation
          # error using the `errors`' `add` method. Its
          # arguments are (in order):
          # - A symbol for the invalid column
          # - An error message as a string
          self.errors.add(:body, "must not have monkeys")
        end
      end
end
