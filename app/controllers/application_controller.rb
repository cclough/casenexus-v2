class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :update_last_online_at

  def completed_user
    redirect_to complete_profile_account_path unless current_user.completed?
  end

  # Authenticate for active admin
  def authenticate_admin_user!
    if !user_signed_in? || current_user.admin == false
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  # Redirection after sign in with devise
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.admin?
      dashboard_path # "/admin" We don't have the admin yet
    else
      dashboard_path
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
end
