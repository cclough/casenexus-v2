ActiveAdmin.register User do
  index do
    column :id
    column :email
    column :first_name
    column :last_name
    column :status_moderated
    column :status_approved
  end
  
end
