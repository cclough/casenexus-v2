class AnswersController < ApplicationController


  def create
    @answer = current_user.answers.build(params[:answer])

    if @answer.save
      flash[:success] = 'Answer posted'
      redirect_to @answer.question
    else
      flash[:error] = @answer.errors.full_messages.map {|error| "#{error}<br>"}.join
      redirect_to @answer.question
    end

  end

  def show
    @question = Answer.find(params[:id]).question
    redirect_to @question
  end

end
