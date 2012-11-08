ActiveAdmin.register User do
  index do
    default_actions
    column :id
    column :email
    column :first_name
    column :last_name
    column :status_moderated
    column :status_approved
  end

  member_action :approve, method: :put do
    user = User.find(params[:id])
    user.status_approve!
    flash[:notice] = "Status approved"
    if params[:dashboard]
      redirect_to admin_dashboard_path
    else
      redirect_to admin_users_path
    end
  end

  member_action :reject, method: :put do
    user = User.find(params[:id])
    user.status_reject!
    flash[:notice] = "Status rejected"
    if params[:dashboard]
      redirect_to admin_dashboard_path
    else
      redirect_to admin_users_path
    end
  end
  
end
