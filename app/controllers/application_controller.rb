class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :update_last_online_at
  before_filter :set_timezone 


  before_filter :authenticate_user!, only: [:online_panel, :online_user_item]
  before_filter :completed_user, only: [:online_panel, :online_user_item]

  helper_method :correct_user



  def online_panel
    render partial: "shared/online_panel", layout: false
  end

  def online_user_item
    # @online_user = User.find(params[:user_id])
    # @online_user_type = params[:online_user_type]

    render partial: "shared/online_user_item"
  end



  def set_timezone  
    Time.zone = current_user.time_zone if current_user
  end
  
  def completed_user
    redirect_to complete_profile_account_path, notice: flash[:notice] unless current_user.completed?
  end

  # Redirection after sign in with devise
  def after_sign_in_path_for(resource_or_scope)
    if session[:user_return_to].blank?
      map_path
    else
      session[:user_return_to]
    end
  end

  # Redirect after sign out with devise
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def update_last_online_at
    if user_signed_in?
      current_user.update_column(:last_online_at, Time.now())
    end
  end


  def correct_user( object, path )
    redirect_to path unless object.user == current_user
  end



end
