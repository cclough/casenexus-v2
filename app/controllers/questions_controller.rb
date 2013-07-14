class QuestionsController < ApplicationController


	def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
		  @questions = Question.all
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

	def update
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
