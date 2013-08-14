class VotesController < ApplicationController


  before_filter :get_voteable, only: [:up, :down, :control]


  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
    @voteable = @vote.voteable

    respond_to do |format|
      format.js { render :action => "control_update" }
      flash[:success] = "Your vote has been retracted."
    end
  end

  def control
    render partial: "control", locals: { voteable: @voteable }, layout: false
  end


  def up
    respond_to do |format|
      begin
        current_user.vote_for(@voteable)
        format.js { render :action => "control_update" }
        flash.now[:success] = 'Your vote has been cast.'
        # render nothing: true, :status => 200
      rescue ActiveRecord::RecordInvalid
        format.js { render :action => "control_update" }
        flash.now[:error] = 'You cannot vote on your own content.'
        # render nothing: true, :status => 404
      end
    end
  end


  def down
    respond_to do |format|
      begin
        current_user.vote_against(@voteable)
        format.js { render :action => "control_update" }
        flash.now[:success] = 'Your vote has been cast.'
        # render nothing: true, :status => 200
      rescue ActiveRecord::RecordInvalid
        format.js { render :action => "control_update" }
        flash.now[:error] = 'You cannot vote on your own content.'
        # render nothing: true, :status => 404
      end
    end
  end

  private

  def get_voteable
      voteable_class = params[:voteable_type].constantize
      @voteable = voteable_class.find(params[:voteable_id])
  end

end
