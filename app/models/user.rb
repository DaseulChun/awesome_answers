class User < ApplicationRecord
  has_secure_password
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  validates :email, presence: true, uniqueness: true
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
