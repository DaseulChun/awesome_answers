class AnswersController < ApplicationController
  # this was created with rails g controller answers

  before_action :authenticate_user! 
  
  def create
      @question = Question.find params[:question_id]
      @answer = Answer.new answer_params
      @answer.user = current_user
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

      if can? :crud, @answer
        @answer.destroy
        redirect_to question_path(@question),
        notice: 'Question Deleted'
      else
        # head will send an empty HTTP response with 
        # a particular response code, in this case
        # Unauthorized - 401
        # http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/
        head :unauthorized
        # redirect_to root_path, alert: 'Not Authorized'
      end

  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end

