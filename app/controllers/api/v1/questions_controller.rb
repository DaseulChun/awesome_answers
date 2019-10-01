class Api::V1::QuestionsController < Api::ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update, :edit]

  def index
    questions = Question.order(created_at: :desc)
    # This allows us to use a seperate serializer to
    # render json of questions in this list. In this case we are keeping the data limited to the minimum we need. (Good practice!)
    render json: questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    render json: @question
  end

  def create
    question = Question.new question_params
    question.user = current_user

    if question.save
      render json: { id: question.id }
    else
      render(
        json: { errors: question.errors }, 
        status: 422 # Unprocessable Entity
      )
    end
  end

  def edit
    
  end

  def update
    if @question.update question_params
      render json: { id: @question.id }
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    render json: { status: 200 }, status: 200
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question ||= Question.find params[:id]
  end
end
