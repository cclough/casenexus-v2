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

  end

  member_action :reject, method: :put do

  end
  
end
