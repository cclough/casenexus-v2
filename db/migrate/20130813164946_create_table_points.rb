class CreateTablePoints < ActiveRecord::Migration
  def up
    create_table :points do |t|
      t.integer  :user_id
      t.integer  :method_id
      t.string   :pointable_type
      t.integer  :pointable_id
      t.datetime :created_at
    end
  end

  def down
    drop_table :points
  end
end
