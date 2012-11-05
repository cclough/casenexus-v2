class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user
      t.references :invited

      t.string :code

      t.string :name
      t.string :email

      t.timestamps
    end

    add_index :invitations, :user_id
    add_index :invitations, :invited_id
  end
end
