Rails.application.routes.draw do

  # get '/questions/new', {to: "questions#new", as: :new_question}
  #new_question_path, new_question_url
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #handles submissions of new questions form
  # post 'questions', {to: 'questions#create', as: :questions}

  #redirect to show page after user creates question
  # get '/questions/:id', {to: "questions#show", as: :question}

  #question index page
  # get '/questions', {to: 'questions#index'}

  #question edit page
  # get '/questions/:id/edit', {to: 'questions#edit', as: :edit_question}

  #update action handles the submission of form from the question edit page
  # patch '/questions/:id', {to: 'questions#update'}

  #delete action lets user delete the question
  # delete '/questions/:id', { to: 'questions#destroy'}

  # The option: 'defaults: {format: :json} will
  # set 'json' as the default response format for all
  # routes contained within the block of the namespace.
  # The namespace method in Rails routes, makes it so
  # it will automatically look in a directory api, then
  # a subdirectory v1 for questions controller.
  namespace :api, defaults: { format: :json } do
    # /api...
    namespace :v1 do
      # /api/v1...
      resources :questions
      # /api/v1/questions...
      resource :session, only: [:create, :destroy]
      # /api/v1/user
      resources :users, only: [:create] do
        # api/v1/user/current
        get :current, on: :collection
        # default
        # /api/v1/users/:id/current
        # on: :member
        # /api/v1/users/:user_id/current
      end
    end
    
    # The following route will match any URL that hasn't been 
    # matched already inside of the "/api" namespace

    # The "*" prefix in the routes path allows this route wildcard
    # match ANYTHING

    # The "via:" argument is require and is used to specify
    # which methods this route applies to.
    # Example:
    # via: [get,:post,:patch]
    # via: :all will match all possible methods.
    match "*unmatched", via: :all, to: "application#not_found"
  end

  resources :questions do
    resources :answers, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]
    resources :publishings, only: :create
    # The `shallow: true` named argument will separate
    # routes that require the parent from those that don't.
    # Routes that require the parent will not change (i.e. index, new, create).
    # Routes that don't require the parent (i.e. show, edit, update,
    # destroy) will have the parent prefix (i.e. /question/:question_id) removed

    # Example
    # /questions/1/likes/5 becomes: /likes/5

    # /questions/Liked
    # Use the 'on' named argument to specify how a nested route
    # behaves relative to its parent.

    # 'on: :collection' means that it acts on the entire resource
    # All questions in this case. 

    # 'on: :member' means that it acts on a single resource. 
    # A single question in this case. 
    get :liked, on: :collection
  end

  # resource :session, only: [:new, :create, :destroy]

  resources :users, shallow: true, only: [:new, :create, :show] do
    resources :gifts, only: [:new, :create] do
      resources :payments, only: [:new, :create]
    end
  end

  get "/auth/github", as: :sign_in_with_github
  get "/auth/:provider/callback", to: "callbacks#index"
  # Above route is like this: 
  # get "/auth/github/callback", to: "callbacks#index"
  # get "/auth/twitter/callback", to: "callbacks#index"

  resources :sessions, only: [:new, :create] do 
    delete :destroy, on: :collection
  end
  
  resources :job_posts, only: [:new, :create, :show, :destroy, :index]

  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  
  # the above will generate the following two routes for answers:
  # question_answers POST/
  # questions:question_id//answers(.:format)
  # answers#create
  # question_answer DELETE /
  # questions/:question_id
  # answers/:id(.:format) answers#destroy


  # This defines a route rule that says when we receive
  # a GET request with the URL '/', handle it with the
  # WelcomeController with the index action inside that
  # controller.
  get('/', {to: 'welcome#index', as: 'root'})

  get '/contacts/new', {to: 'contacts#new' }
  post '/contacts', {to: 'contacts#create'}
  # get '/questions/:id', {to: 'questions#show', as: :question }
end
