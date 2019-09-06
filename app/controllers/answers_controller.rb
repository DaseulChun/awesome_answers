# class AnswersController < ApplicationController
#   # this was created with rails g controller answers

#   def create
#     @question = Question.find params[:question_id]
#     answer_params = params.require(:answer).permit(:body)
#     @answer = Answer.new answer_params
#     @answer.question = @question

#     if @answer.save
#       redirect_to question_path(@question),
#       notice: 'Answer successfully created!'
#     else
#       @answers = @questions.answers.order(created_at: :desc)
#       render 'questions/show'
#     end
#   end

#   def destroy
#     @question = Question.find params[:question_id]
#     @answer = Answer.find params[:id]
#     @answer.destroy
#     redirect_to question_path(@question),
#     notice: 'Question Deleted'
#   end

#   private

#   def answer_params
#     params.require(:answer).permit(:body)
#   end

# end

class AnswersController < ApplicationController
  # this was created with rails g controller answers
def create
    @question = Question.find params[:question_id]
    answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new answer_params
    @answer.question = @question
    if
    @answer.save
    redirect_to question_path(@question),
    notice: 'Answer successfully created!'
    else
        @answers = @questions.answers.order(created_at: :desc)
        render 'questions/show'
    end
end
def destroy
    @question= Question.find params[:question_id]
    @answer = Answer.find params[:id]
    @answer.destroy
    redirect_to question_path(@question),
    notice: 'Question Deleted'
end
private
def answer_params
    params.require(:answer).permit(:body)
end
end

