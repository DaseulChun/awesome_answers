FactoryBot.define do
  # FactoryBot.attributes_for(:job_post)
  # Uses the factory to return a plain hash of the parameters required
  # to create a JobPost.

  # FactoryBot.build(:job_post)
  # Returns a new unpersisted instance of a JobPost
  # (using the factory)

  # FactoryBot.create(:job_post)
  # Returns a persisted instance of a JobPost
  # (using the factory)
  
  # All of your factories must always generate valid instances of your data.
  # ALWAYS!
  factory :job_post do
    title {Faker::Job.title}
    description {Faker::Job.field}
    min_salary { rand(20_001..100_000) }
    max_salary { rand(100_001..300_000) }
    company_name {Faker::Company.name }
    # The line below will create a user (using its factory)
    # before creating a job post. Then it will assoiate that user to the job post
    # This is necessary to pass the validation added by belongs_to :user
    association(:user, factory: :user)
    # If the factory has the same name as the association
    # You can shorten this to: 
    # user
  end
end
