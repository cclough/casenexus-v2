class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer     "tag_id",         null: false
      t.integer     "taggable_id"
      t.string      "taggable_type"
    end
  end
end
