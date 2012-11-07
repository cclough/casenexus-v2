ActiveAdmin.register Case do
  index do
    default_actions
    column :id
    column :date
    column :subject
    column :user
    column :interviewer
  end
  
end
