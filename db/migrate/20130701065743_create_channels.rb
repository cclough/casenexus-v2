class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.integer     "country_id"
      t.integer     "university_id"
    end
  end
end
