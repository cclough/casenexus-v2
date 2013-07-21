class QuestionsController < ApplicationController


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

  def edit
    @question = Question.find(params[:id])
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

  def vote_up
    begin
      current_user.vote_for(@question = Question.find(params[:id]))
      render :nothing => true, :status => 200
    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end
  end

  def vote_down
    begin
      current_user.vote_against(@question = Question.find(params[:id]))
      render :nothing => true, :status => 200
    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end
  end

end
