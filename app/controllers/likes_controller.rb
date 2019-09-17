class LikesController < ApplicationController

  before_action :authenticate_user!

  def create
    # we are not using it as an instanve variable like @question
    # becoz we not gonna render any page 
    question = Question.find(params[:question_id])
    like = Like.new(user: current_user, question: question)

    if !can?(:like, question)
      redirect_to question, alert: "can't like your own question"
    elsif like.save
      flash[:success] = "Question Liked"
      redirect_to question_path(question)
    else
      flash[:danger] = like.errors.full_messages.join(", ")
      redirect_to question_path(question)
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    # above is better than below : why? scoping to finding less likes 
    # like = Like.find(params[:id])
    if can? :destroy, like
      like.destroy
      flash[:success] = "Question unliked"
      redirect_to question_path(like.question)
    else
      flash[:danger] = "Can't delete like"
      redirect_to question_path(like.question)
    end
  end

end
