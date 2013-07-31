class QuestionsController < ApplicationController


  before_filter :correct_user, :only => [:edit, :update, :destroy]

	def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag]).paginate(per_page: 20, page: params[:page]).search_for(params[:search])
    else
		  @questions = Question.paginate(per_page: 20, page: params[:page]).search_for(params[:search])
	  end
  end

	def show
		@question = Question.find(params[:id])
		@answer = Answer.new
	end

	def new 
		@question = current_user.questions.build
	end

	def create
    @question = current_user.questions.build(params[:question])

    if @question.save
      flash[:success] = 'Question posted'
      redirect_to @question
    else
      render 'new'
    end

	end

  def edit
    @question = Question.find(params[:id])
  end
  
	def update
    @question = Question.find(params[:id])

    if @question.update_attributes(params[:question])
      flash[:success] = 'Your question has been updated'
      redirect_to @question
    else
      render "edit"
    end
	end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = "Your question has now been deleted."
    redirect_to questions_path
  end

  private

    def correct_user
      @question = Question.find params[:id]
      redirect_to @question unless current_user == @question.user
    end
  

end
