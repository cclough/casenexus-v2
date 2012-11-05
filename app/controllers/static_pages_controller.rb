class StaticPagesController < ApplicationController

  def home
    if params[:code]
      if params[:code] == "BYPASS_CASENEXUS_INV"
        session[:code] = "BYPASS_CASENEXUS_INV"
      elsif @invitation = Invitation.where(code: params[:code]).exists?
        @invitation = Invitation.where(code: params[:code]).first
        if @invitation.invited
          session[:code] = nil
          flash[:notice] = "Invitation already used"
        else
          flash[:notice] = "Hi #{@invitation.name}, welcome to Casenexjs"
          session[:code] = params[:code]
        end
      end
    end
    if signed_in?
      flash[:notice] = "You should be logged off to accept an Invitation" if @invitation
      redirect_to dashboard_path
    else
      @user = User.new
      @user.invitation_code = session[:code]
    end
  end

  def about
    @user = User.new unless signed_in?
  end

  def terms
    @user = User.new unless signed_in?
  end

end
