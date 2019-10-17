class PublishingsController < ApplicationController
  before_action :authenticate_user! 
  def create
    q = Question.find params[:question_id]
    q.publish!
    redirect_to q, notice: 'Question published'
  end
end
