class CreateSiteContacts < ActiveRecord::Migration
  def change
    create_table :site_contacts do |t|
      t.references :user

      t.string :email
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
