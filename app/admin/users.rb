ActiveAdmin.register User do
  index do
    default_actions
    column :id
    column :email
    column :first_name
    column :last_name
    column :status_moderated
    column :status_approved
    column "Moderation" do |user|
      links = ''.html_safe
      if user.status_moderated == false
        links << link_to("Approve", approve_admin_user_path(user, dashboard: true), method: :put, class: 'member_link view_link')
        links << link_to("Reject", reject_admin_user_path(user, dashboard: true), method: :put, class: 'member_link view_link')
      else
        links << "&nbsp;".html_safe
      end
      links
    end

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
