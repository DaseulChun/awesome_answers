class User < ApplicationRecord
  has_secure_password
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :job_posts, dependent: :destroy
  # by has_many, we are able to use user.job_posts method from now on

  validates :email, presence: true, uniqueness: true
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
