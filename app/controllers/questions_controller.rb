class QuestionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  # these two belows's ORDER DOES MATTER
  # Coz authorize! method need @question args, which is coming from find_question method
  # so find_question needs to executed first
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  # rails g controller questions new
  def new
    @question = Question.new
    render :new
  end

  def create
    @question = Question.new question_params
    @question.user = current_user

    if @question.save
      flash[:notice] = "Question created successfully"
      #if question is saved successfully redirect them to the question they just created
      redirect_to question_path(@question)
    else
      #if question is not saved successfully render new
      render :new
    end

  end

  def show
    # @question = Question.find(params[:id])
    
    @answer = Answer.new

    @answers = @question.answers.order(created_at: :desc)

    @like = @question.likes.find_by(user: current_user)

    respond_to do |format|
      format.html { render }
      format.json { render json: @question }
    end
  end

  def index
    if params[:tag]
      # @tag = Tag.find_by(name: params[:tag])
      # To fix some bug, 
      # the bug is, @tag will be Nil when we type the url by ourselves
      # below code won't throw any error 
      # but with no questions associated with it
      # just showing the tag itself in the index page
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @questions = @tag.questions.order(created_at: :desc)
    else
      @questions = Question.order(created_at: :desc)
    end
  end

  def edit
    redirect_to root_path, alert: "Not Authorized" unless can?(:crud, @question)
  end

  def update
    #for user to update the existing question, they must edit and then save it
    if @question.update question_params
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy 
    flash[:notice] = "Question destroyed!"
    @question.destroy
    redirect_to questions_path
  end

  def liked
    @questions = current_user.liked_questions.order(created_at: :desc)
  end


  private

  def question_params
    #params.require(:question): we must have a question object on the params of this request
    params.require(:question).permit(:title, :body, :tag_names)
  end

  def find_question
    #this will get the current value inside of the db
    @question = Question.find params[:id]
  end

  def authorize!
    redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @question)
  end

end
