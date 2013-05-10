ActiveAdmin.register User do
  index do
    default_actions
    column :id
    column :email
    column :first_name
    column :last_name
    column :active
  end

  
end
