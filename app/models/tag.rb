class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  # The case_sensitive: false option will make uniqueness validation
  # ignore case. For example, two records with name "Arts" or "ARTS" can't coexist.
  before_validation :downcase_name

  private

  def downcase_name
    self.name&.downcase!
    # basically equivalent to:
    # self.name = self.name.downcase
  end

end
