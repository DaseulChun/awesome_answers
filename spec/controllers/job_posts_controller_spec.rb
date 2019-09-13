# require 'rails_helper'

# RSpec.describe JobPostsController, type: :controller do
#   describe '#new' do
#     it "renders a new template" do
#       # Given
#       # Defaults

#       # When
#       # A GET request is made to the new action
#       get(:new)

#       # Then
#       # The response contains the rendered template: 'new'

#       # The `response` object is available inside any controller
#       # It is similar to the response available in Express Middleware
#       # however we rarely interact with it directly in Rails.
#       # RSPEC makes it available when testing to verify its contents

#       # Here we verify with the render_template matcher that it contains 
#       # the right rendered template.
#       expect(response).to(render_template(:new))
#     end

#     it "sets an instance variable with a new job post" do
#       # Given

#       # When
#       get(:new)

#       # Then
#       # assigns(:job_post) - returns the value of the instance
#       # variable @job_post from the our JobPostsController. Only available
#       # with the rails-controller-testing gem.
#       expect(assigns(:job_post)).to(be_a_new(JobPost))
#       # The above matcher will verify that the expected value is a
#       # new instance of the JobPost model.
#     end
#   end

#   describe "#create" do
#     # context is functionally the same as describe, but we
#     # use it to organize groups of branching code paths.
#     context "with valid parameters" do
#       it "saves a new job post to the db" do
#         count_before = JobPost.count
#         # passing the post request to create action to controller with params
#         post(:create, params: {job_post: FactoryBot.attributes_for(:job_post)})
#         # is equivalent to: 
#         # post(:create, params: {job_post: {title: "Web Developer", description: "Build Brett's final project for him", min_salary: 1000, max_salary: 500_000}})
#         count_after = JobPost.count
#         expect(count_after).to eq(count_before + 1)
#       end
      
#       it "redirects to the show page of ta job post" do
#         post(:create, params: {job_post: {title: "Web Developer", description: "Build Brett's final project for him", min_salary: 1000, max_salary: 500_000}})
#         job_post = JobPost.last
#         expect(response).to(redirect_to(job_post_path(job_post.id)))
#       end
#     end

#     context "with invalid parameters" do
#       it "does not create a job post" do
#         count_before = JobPost.count
#         # passing the post request to create action to controller with params
#         post(:create, params: {job_post: {title: nil, description: "Build Brett's final project for him", min_salary: 1000, max_salary: 500_000}})
#         count_after = JobPost.count
#         expect(count_after).to eq(count_before)
#       end

#       it "renders the new template" do
#         post(:create, params: {job_post: {title: nil, description: "Build Brett's final project for him", min_salary: 1000, max_salary: 500_000}})
#         expect(response).to(render_template(:new))
#       end

#       it "assigns an invalid job postas an instance variable" do
#         post(:create, params: {job_post: {title: nil, description: "Build Brett's final project for him", min_salary: 1000, max_salary: 500_000}})
#         expect(assigns(:job_post)).to be_a(JobPost)
#         expect(assigns(:job_post).valid?).to be false
#       end

#     end

#   end

#   describe '#show' do
#     it "renders the show template" do
#       job_post = FactoryBot.create(:job_post)
#       get(:show, params: {id: job_post.id })
#       expect(response).to render_template :show
#     end
#     it "sets @job_post for the shown object" do
#       job_post = FactoryBot.create(:job_post)
#       get(:show, params: {id: job_post.id })
#       expect(assigns(:job_post)).to eq(job_post)
#     end
#   end

# end

# Refactored Codes
require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do

  def current_user
    @current_user ||= FactoryBot.create(:user)
  end

  describe '#new' do
    context 'without signed in user' do
      it "redirects the user to session new" do
        get(:new)
        expect(response).to redirect_to new_session_path
      end
      it "sets a danger flash message" do
        get(:new)
        expect(flash[:danger]).to be
      end
    end

    context 'with signed in user' do
      # Use before to run a block of code before all tests
      # inside of a block. In this case, the following will run
      # before the two tests inside this context block
      # we want a signed in user!!
      before do
        # current_user = FactoryBot.create(:user)
        # To simulate signing in a user, se a 'user_id' in
        # the session. rspec makes controller's session available
        # inside your tests.
        session[:user_id] = current_user.id
      end
      it "renders a new template" do
        # Given
        # Defaults
        # When
        # A GET request is made to the new action
        get(:new)
        # Then
        # The response contains the rednered template: `new`

        # The `response` object is available inside any controller
        # It is similar to the response available in Express Middleware
        # however we rarely interact with it directly in Rails.
        # RSPEC makes it available when testing to verify its contents

        # Here we verify with the render_template matcher that it contains
        # the right rendered template.
        expect(response).to(render_template(:new))
      end

      it "sets an instance variable with a new job post" do
        get(:new)

        # assigns(:job_post) - returns the value of the instance
        # variable @job_post from the our JobPostsController. Only available
        # with the rails-controller-testing gem.
        expect(assigns(:job_post)).to(be_a_new(JobPost))
        # The above matcher will verify that the expected value is a
        # new instance of the JobPost model.
      end
    end
  end

  describe "#create" do
    # context is functionally the same as describe, but we
    # use it to organize groups of branching code paths.
    def valid_request
      post(:create, params: {job_post: FactoryBot.attributes_for(:job_post)})
    end

    context "without signed in user" do
      it "redirects to the new session page" do
        valid_request
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with signed in user" do
      before do
        # below line could be omitted coz, of the def you declared at the very top
        # current_user = FactoryBot.create(:user)

        # To simulate signing in a user, set a `user_id` in
        # the session. rspec makes controller's session available
        # inside your tests.
        session[:user_id] = current_user.id
      end

      context "with valid parameters" do
        it 'saves a new job post to the db' do
          count_before = JobPost.count
          valid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before + 1)
        end
        it 'redirects to the show page of that job post' do
          valid_request
          job_post = JobPost.last
          expect(response).to(redirect_to(job_post_path(job_post.id)))
        end
      end

      context "with invalid parameters" do
        def invalid_request
          post(:create, params: {job_post: FactoryBot.attributes_for(:job_post, title: nil)})
        end
        it 'does not create a job post in the db' do
          count_before = JobPost.count
          invalid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before)
        end
        it 'renders the new template' do
          invalid_request
          expect(response).to render_template(:new)
        end

        it 'assigns an invalid job post as an instance variable' do
          invalid_request
          expect(assigns(:job_post)).to be_a(JobPost)
          expect(assigns(:job_post).valid?).to be false
        end
      end
    end
  end

  describe "#show" do
    it "renders the show template" do
      job_post = FactoryBot.create(:job_post)
      get(:show, params: {id: job_post.id })
      expect(response).to render_template :show
    end

    it "sets @job_post for the shown object" do
      job_post = FactoryBot.create(:job_post)
      get(:show, params: {id: job_post.id })
      expect(assigns(:job_post)).to eq(job_post)
    end
  end

  describe "#destroy" do
    context "without signed in user" do
      it "redirects to the new session page" do
        job_post = FactoryBot.create(:job_post)
        delete(:destroy, params: {id: job_post.id })
        expect(response).to redirect_to new_session_path
      end
    end

    context "with signed in user" do
      before do
        session[:user_id] = current_user.id
      end

      # After fix it, now we all get all the "with job post owner" test failing
      # it's not deleting the post, still getting the post
      context "with job post owner" do
        it "removes the job post from the db" do
          # it's creating the job_post with a newly created user(random one) from the factory
          # when the post is being created at the same time
          # job_post = FactoryBot.create(:job_post)

          # so we need to change to: 
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: {id: job_post.id })
          expect(JobPost.find_by(id: job_post.id)).to(be(nil))
        end
        it "redirects to the job posts index" do
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: {id: job_post.id })
          expect(response).to redirect_to(job_posts_path)
        end
        it "sets a flash message" do
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: {id: job_post.id })
          expect(flash[:danger]).to be
        end
      end

      context "with job post non-owner" do
        it "doesn't remove the job post" do
          job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: {id: job_post.id })
          expect(JobPost.find_by(id: job_post.id)).to(eq(job_post))
        end
        it "redirects to job post show" do
          job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: {id: job_post.id })
          expect(response).to redirect_to(job_post_path(job_post))
        end

      end

    end
  end

  describe "#index" do
    # Refactoring to NOT repeat the 'get :index'
    before do
      get :index
    end
    it "renders the index template" do
      # get :index
      expect(response).to render_template(:index)
    end
    it "assigns an instance variable to all created job posts" do
      # get :index
      job_post_1 = FactoryBot.create(:job_post)
      job_post_2 = FactoryBot.create(:job_post)
      expect(assigns(:job_posts)).to eq([job_post_2, job_post_1])
    end

  end
end
