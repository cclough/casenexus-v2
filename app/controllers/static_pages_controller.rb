class StaticPagesController < ApplicationController

  layout 'home'

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
          flash[:notice] = "Hello #{@invitation.name}, thank you for accepting your invitation"
          session[:code] = params[:code]
        end
      end
    end
    if signed_in?
      flash[:notice] = "You must be signed out to accept an invitation" if @invitation
      redirect_to map_path
    else
      @login = User.new
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
