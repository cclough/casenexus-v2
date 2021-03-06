class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :authenticate_user!, :unless => :devise_controller?

  before_filter :update_last_online_at
  before_filter :set_timezone
  before_filter :miniprofiler
  
  def set_timezone  
    Time.zone = current_user.time_zone if current_user && current_user.completed
  end
  
  def completed_user
    redirect_to complete_account_path, notice: flash[:notice] unless current_user.completed?
  end

  # Redirection after sign in with devise
  def after_sign_in_path_for(resource_or_scope)
    if session[:user_return_to].blank?
      "/"
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

  private
  def miniprofiler # enables mini profiler for admin user in production
    if signed_in?
      Rack::MiniProfiler.authorize_request if current_user.admin?
    end
  end

end
