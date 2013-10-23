class AnswersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user
  before_filter :correct_user, :only => [:edit, :update, :destroy]

  layout "questions"

  def show
    @answer = Answer.find(params[:id])
    @question = @answer.question
    redirect_to @question
  end

  def create
    @answer = current_user.answers.build(params[:answer])

    if @answer.save
      flash[:success] = 'Answer posted.'
      redirect_to @answer.question
    else
      flash[:error] = @answer.errors.full_messages.map {|error| "#{error}<br>"}.join
      redirect_to @answer.question
    end

  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question # for side column
  end
  
  def update
    @answer = Answer.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash[:success] = 'Your answer has been updated.'
      redirect_to @answer.question
    else
      @question = @answer.question
      render "edit"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    flash[:success] = "Your answer has now been deleted."
    redirect_to @answer.question
  end

  private

    def correct_user
      @answer = Answer.find params[:id]
      redirect_to @answer unless current_user == @answer.user
    end

end
