class AnswersController < ApplicationController


  layout "questions"

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question # for side column
  end

  def show
    @question = Answer.find(params[:id]).question
    redirect_to @question
  end

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

  def update
    @answer = Answer.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash[:success] = 'Your answer has been updated'
      redirect_to @answer.question
    else
      render "edit"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    flash[:success] = "Your answer has now been deleted."
    redirect_to @answer.question
  end

end
