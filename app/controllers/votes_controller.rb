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


  # MAKE THIS INTO ONE VOTE FUNCTION ONCE YOU ARE SURE IT WONT CAUSE ANY PROBLEMS
  def up

    respond_to do |format|
      begin

        # UNLOCKABLE
        if current_user.points_tally >= 5
          current_user.vote_for(@voteable)
          flash.now[:success] = 'Your vote has been cast.'
          # render nothing: true, :status => 200
        else
          flash.now[:error] = 'You must have more than 5 reputation points to up vote'
        end

        format.js { render :action => "control_update" }

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

        # UNLOCKABLE
        if current_user.points_tally >= 20
          current_user.vote_against(@voteable)
          flash.now[:success] = 'Your vote has been cast.'
          # render nothing: true, :status => 200
        else
          flash.now[:error] = 'You must have more than 20 reputation points to down vote'
        end

        format.js { render :action => "control_update" }

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
