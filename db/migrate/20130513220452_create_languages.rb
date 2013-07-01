class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.text        "name"
      t.text        "country_code"
    end
  end
end
