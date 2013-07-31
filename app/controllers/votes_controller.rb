class VotesController < ApplicationController

  before_filter :get_voteable

  def up
    respond_to do |format|
      
      begin

        current_user.vote_for(@voteable)

        format.js
        flash.now[:success] = 'Vote saved'

        # render nothing: true, :status => 200

      rescue ActiveRecord::RecordInvalid

        format.js
        flash.now[:error] = 'Vote error'

        # render nothing: true, :status => 404

      end

    end
  end

  def down
    begin
      current_user.vote_against(@voteable)
      render nothing: true, :status => 200
    rescue ActiveRecord::RecordInvalid
      render nothing: true, :status => 404
    end
  end

  private

  def get_voteable
      voteable_class = params[:voteable_type].constantize
      @voteable = voteable_class.find(params[:voteable_id])
  end

end
