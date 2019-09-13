require 'rails_helper'

# To generate this file after you have aready
# created the model, run:
# rails g rspec:model job_post

# To run your tests with rspec do:
# rspec

# or to get more detailed info about the running tests:
# rspec -f d

RSpec.describe JobPost, type: :model do

  # The `describe` is used to group related tests together.
  # It's primarily used as an orginizational tool. All of the
  # grouped tests should be written inside the block of the method.
  describe "validates" do
    # 'it' is another rspec keyword which is used to define an 
    # 'example' (test case). The string argument often uses the 
    #  word should and is meant to describe what specific behavior
    #  should happen inside the block.
    #  in this case, it = JobPost
    it("should require a title") do
      # Given
      # An instance of a JobPost without a title
      job_post = JobPost.new
      
      # When
      # Validations are triggered
      job_post.valid?
      
      # Then
      # There's an error related to the title in the error object.
      
      # The following will pass the test if the errors.messages
      # hash has a key named :title. This only occurs, if title validation
      # fails.

      # Use the 'expect' method instead of `assert_*` from minitest
      # to write assertions
      # It takes a single argument which is the actul value or the
      # one to be tested.
      # We then call the `to` method on the object's return with a
      # `matcher` to perform the verification of the value.
      expect(job_post.errors.messages).to(have_key(:title))
    end
     
    it "should have a unique title" do
      # Given
      # one job post in the db and a new instance of job post
      # with the same title
      # persisted_jp = JobPost.create(title: "Imagination Engineer", description: "Some valid description")
      persisted_jp = FactoryBot.create(:job_post, title: "Imagination Engineer")
      jp = JobPost.new(title: persisted_jp.title)

      # When
      # Validations are triggered
      jp.valid?

      # Then
      # Error on title
      expect(jp.errors.messages).to(have_key(:title))
      expect(jp.errors.messages[:title]).to(include("has already been taken"))
      # To get a list of all possible matchers for tests, go to:
      # https://relishapp.com/rspec/rspec-expectations/v/3-7/docs/built-in-matchers
    end

    it "should have a description" do
      # Given
      # An instance of a JobPost without a title
      # job_post =  JobPost.new
      job_post = FactoryBot.build(:job_post, description: nil)
      # When
      # Validations are triggered
      job_post.valid?
      # Then
      # There's an error related to the title in the error object.

      # The following will pass the test if the errors.messages
      # hash has a key named :title. This only occurs, if title validation
      # fails.

      # Use the 'expect' method instead of `assert_*` from minitest
      # to write assertions
      # It takes a single argument which is the actul value or the
      # one to be tested.
      # We then call the `to` method on the object's return with a
      # `matcher` to perform the verification of the value.
      expect(job_post.errors.messages).to(have_key(:description))
    end

  end

  # As per the ruby docs, methods that are described with a '.' are
  # class methods while those described with a '#' in front are instance methods
  describe(".search") do
    it "should return job posts containing the search term" do
      # Given
      # 3 Job posts in the db
      job_post_a = FactoryBot.create(:job_post,
        title: "Software Engineer",
        description: "Best job"
      )

      job_post_b = FactoryBot.create(:job_post,
        title: "Programmer",
        description: "Develop some software"
      )

      job_post_c = FactoryBot.create(:job_post,
        title: "Web Developer",
        description: "Build cool applications"
      )

      # below was refractored... to above ones
      # coz we got failure after making the test for job_posts controller
      # job_post_c = JobPost.create(
      #   title: "Web Developer",
      #   description: "Build cool applications"
      # )

      # When
      # Searching for software
      results = JobPost.search("software")

      # Then
      # Should return Job post A & B
      expect(results).to(eq([job_post_a, job_post_b]))
    end  
  end
end
