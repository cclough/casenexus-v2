class ApplicationController < ActionController::Base
  protect_from_forgery

  def completed_user
    redirect_to edit_account_path unless current_user.completed?
    #redirect_to new_user_registration_path, notice: "Please complete the sign up process." unless current_user.completed?
  end

  # Redirection after sign in with devise
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.admin?
      "/admin"
    else
      dashboard_path
    end
  end

  # Redirect after sign out with devise
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
