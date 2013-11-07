class AddColumnDomain2ToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :domain2, :string
  end
end
