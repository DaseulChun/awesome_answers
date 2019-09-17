class User < ApplicationRecord
  has_secure_password
  # above has many features
  # if the password confirmation field is present, 
  # it will requires to compare with password and password confirmation

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :job_posts, dependent: :destroy
  # by has_many, we are able to use user.job_posts method from now on

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question
  # The has_many `through` argument takes the name of another
  # has_many association creating with `has_many :association_name`.
    # If you were to use `has_many :questions` then you will have
    # two `has_many :questions` so one will override the other.
    # To fix this, we can give the association a different name
    # and specify the `source` option so that Rails can figure out
    # the other end of the association.
  # Note: the `source` option has to match a `belongs_to` association 
  # in the join model (Like in this case)


  validates :email, presence: true, uniqueness: true
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
